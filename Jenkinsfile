@Library('tfc-lib') _

flags = gitParseFlags()

dockerConfig = getDockerConfig(['MATLAB','Vivado'], matlabHSPro=false)
dockerConfig.add("-e MLRELEASE=R2022a")
dockerHost = 'docker'

////////////////////////////

packages = ['master']

stage("Build Toolbox") {
    dockerParallelBuild(packages, dockerHost, dockerConfig) { 
        branchName ->
        withEnv(['PACKAGE='+branchName]) {
            sh 'rm -rf doc || true'
            checkout scm
            sh 'git submodule update --init'
            sh 'pip3 install -r ./CI/gen_doc/requirements_doc.txt'
            sh 'make -C ./CI/gen_doc doc_ml'
            sh 'python3 CI/scripts/rename_common.py'
            sh 'make -C ./CI/scripts gen_tlbx'
            archiveArtifacts artifacts: '*.mltbx'
            stash includes: '**', name: 'builtSources', useDefaultExcludes: false
        }
    }
}

/////////////////////////////////////////////////////

boardNames = ['NonHW']

cstage("NonHW Tests", "", flags) {
    dockerParallelBuild(boardNames, dockerHost, dockerConfig) { 
        branchName ->
        withEnv(['BOARD='+branchName]) {
            cstage("NonHW", branchName, flags) {
                unstash "builtSources"
                sh 'make -C ./CI/scripts run_NonHWTests'
            }
        }
    }
}

//////////////////////////////////////////////////////

node('baremetal || lab_b5') {
    stage('Deploy Development') {
        unstash "builtSources"
        uploadArtifactory('RFMicrowaveToolbox','*.mltbx')
    }
    if (env.BRANCH_NAME == 'main') {
        stage('Deploy Production') {
            unstash "builtSources"
            uploadFTP('RFMicrowaveToolbox','*.mltbx')
        }
    }
}

