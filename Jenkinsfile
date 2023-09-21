@Library('tfc-lib') _

dockerConfig = getDockerConfig(['MATLAB','Vivado'], matlabHSPro=false)
dockerConfig.add("-e MLRELEASE=R2022a")
dockerHost = 'docker'

////////////////////////////

packages = ['master']

stage("Build Toolbox") {
    dockerParallelBuild(packages, dockerHost, dockerConfig) { 
        branchName ->
        withEnv(['PACKAGE='+branchName]) {
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

classNames = ['ADAR3002']

stage("Hardware Streaming Tests") {
    dockerParallelBuild(classNames, dockerHost, dockerConfig) { 
        branchName ->
        withEnv(['HW='+branchName]) {
            unstash "builtSources"
            sh 'echo ${HW}'
            // sh 'make -C ./CI/scripts test_streaming'
        }
    }
}

//////////////////////////////////////////////////////

node {
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

