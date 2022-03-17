classdef ADAR3002Tests < HardwareTests
    
    properties(TestParameter)
       props = {...
           'AmpBiasMuteELV',...
           'AmpBiasOperationalELH',...
           'AmpBiasOperationalELV',...
           'AmpBiasResetELV',...
           'AmpBiasSleepELH',...
           'AmpBiasSleepELV',...
           'AmpENMuteELV',...
           'AmpENOperationalELH',...
           'AmpENOperationalELV',...
           'AmpENResetELV',...
           'AmpENSleepELH',...
           'AmpENSleepELV'
           };
       cprops = {...
           'PhasesBeam0H',...
           'PhasesBeam0V',...
           'PowersBeam0H',...
           'PowersBeam0V',...
           'PhasesBeam1H',...
           'PhasesBeam1V',...
           'PowersBeam1H',...
           'PowersBeam1V',...
           };
       beam_props = {...
           {'BeamFIFORD',{'beam0_fifo_rd','beam1_fifo_rd','beam2_fifo_rd','beam3_fifo_rd'}},...
           {'BeamFIFOWR',{'beam0_fifo_wr','beam1_fifo_wr','beam2_fifo_wr','beam3_fifo_wr'}},...
           {'BeamRAMIndex',{'beam0_ram_index','beam1_ram_index','beam2_ram_index','beam3_ram_index'}},...
           {'BeamRAMStart',{'beam0_ram_start','beam1_ram_start','beam2_ram_start','beam3_ram_start'}},...
           {'BeamRAMStop',{'beam0_ram_stop','beam1_ram_stop','beam2_ram_stop','beam3_ram_stop'}},...
           };
       
       beam_props_str = {...
           {'BeamMode',{'beam0_mode','beam1_mode','beam2_mode','beam3_mode'}},...
           {'BeamLoadMode',{'beam0_load_mode','beam1_load_mode','beam2_load_mode','beam3_load_mode'}},...
           };
    end
    properties
        %         uri = 'ip:10.72.162.61';
        uri = 'ip:192.168.86.48';
        author = 'ADI';
    end
    
    methods(TestClassSetup)
        % Check hardware connected
        %         function CheckForHardware(testCase)
        %             Device = @()adi.ADAR3002;
        %             testCase.CheckDevice('ip',Device,testCase.uri(4:end),false);
        %         end
    end
    
    methods (Static)
        function values = clearUnavailable(obj,attrs,values,devices)
            numRows = size(obj.ArrayMapInternal,1);
            numCols = size(obj.ArrayMapInternal,2);
            assert(isequal(size(values),[numRows,numCols]),...
                sprintf('must of size [%dx%d]',numRows,numCols));
            numAttrs = length(attrs);
            for r = 1:numRows
                for c = 1:numCols
                    indx = obj.ArrayMapInternal(r,c);
                    deviceIndx = ceil(indx/numAttrs);
                    attrIndx = mod(indx-1,numAttrs) + 1;
                    
                    %DEBUG
                    if isempty(devices{deviceIndx})
                        values(r,c) = 0;
                    end
                end
            end
            
        end
        
        
        function values = clearUnavailableChannels(obj,channels,values,devices)                        
            tolerance = 0;
            
            % Check dimensions 
            numRows = size(obj.ArrayMapInternal,1);
            numCols = size(obj.ArrayMapInternal,2);
            assert(isequal(size(values),[numRows,numCols]),...
                sprintf('must of size [%dx%d]',numRows,numCols));
            
%             numAttrs = length(channels);
%             numAttrs = length(channels)/length(devices);
            numAttrs = 4;
            for r = 1:numRows
                for c = 1:numCols
                    indx = obj.ArrayMapInternal(r,c);
                    deviceIndx = ceil(indx/numAttrs);
                    attrIndx = mod(indx-1,numAttrs) + 1;
                    
                    %DEBUG
                    if isempty(devices{deviceIndx})
                        values(r,c) = 0;
                        continue;
                    end
                    if isempty(channels{attrIndx})
                        values(r,c) = 0;
                        continue;
                    end   
                end
            end           
        end

        function values = clearUnavailableBeams(attrs,values,devices)
            assert(isequal([length(devices),length(attrs)],size(values)),...
                sprintf('must of size [%dx%d]',length(devices),...
                length(attrs)));

            for deviceIndx=1:length(devices)
                %DEBUG
                if isempty(devices{deviceIndx})
                    if isa(values,'cell')
                        for k = 1:length(values(deviceIndx,:))
                            values{deviceIndx,k} = [];
                        end
                    else
                        values(deviceIndx,:) = 0;
                    end
                    continue;
                end
            end            
        end
        
    end
    
    methods (Test)
        
        function testADAR3002Smoke(testCase)
            bf = adi.ADAR3002('uri',testCase.uri);
            bf();
            bf.release();
        end
        
        function testADAR3002Single(testCase)
            % Test Reading phases
            bf = adi.ADAR3002('uri',testCase.uri);
            bf();
            values = randi([0,3],1,4);
            bf.PhasesBeam0H = values;
            % Check
            rvalues = getAllRelatedChannelAttrs(bf,...
                'raw',bf.PhasesBeam0HChannelNames,true,bf.iioDevices);
            bf.release();
            testCase.verifyEqual(rvalues,values);
        end
        
        function testADAR3002Array(testCase)
            % Test Reading phases
            bf = adi.ADAR3002Array('uri',testCase.uri);
%             bf = adi.ADAR3002Array('uri',testCase.uri,...
%                 'ArrayMap',[1,2,3,4],...
%                 'deviceNames',{'adar3002_csb_0_0'});
            bf();
            values = randi([0,3],2,4);
            bf.PhasesBeam0H = values;
            % Check
            rvalues = getAllRelatedChannelAttrs(bf,...
                'raw',bf.PhasesBeam0HChannelNames,true,bf.iioDevices);
            bf.release();
            testCase.verifyEqual(rvalues,values);
        end
        
        function testADAR3002LongsPeakChannelAttrs(testCase,cprops)
            % Test Reading channel based attrs
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();
            values = randi([1,3],16,16);
            
            cns = get(bf,[cprops,'ChannelNames']);
            values = testCase.clearUnavailableChannels(bf,...
                cns,values,bf.iioDevices);
            set(bf,cprops,values);

            % Check
            cn = get(bf,[cprops,'ChannelNames']);
            rvalues = getAllRelatedChannelAttrs(bf,...
                'raw',cn,true,bf.iioDevices);
            
            bf.release();
            testCase.verifyEqual(rvalues,values);
        end
        
        function testADAR3002LongsPeakDevAttrs(testCase,props)
            % Test Reading phases
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();
            values = randi([0,3],16,16);
            
            p = get(bf,[props,'Attrs']);

            values = testCase.clearUnavailable(bf,...
                p,values,bf.iioDevices);
            
            set(bf,props,values);

            % Check
            rvalues = getAllRelatedDevAttrs(bf,...
                p,bf.iioDevices);
            bf.release();
            
            testCase.verifyEqual(rvalues,values);
        end
        
        function testADAR3002LongsPeakDevAttrsCTRL(testCase)
            % Test Reading update_intf_ctrl
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();
            values = randi([1,2],1,64);r = {'spi','pin'};
            values = r(values);
            
            bf.UpdateIntfCtrl = values;
            % Check
            rvalues = cell(1,64);
            for k=1:64
                if ~isempty(bf.iioDevices{k})
                    rvalues{k} = bf.getDeviceAttributeRAW('update_intf_ctrl',...
                        64,bf.iioDevices{k});
                end
            end
            bf.release();
            
            for di = 1:length(bf.iioDevices)
               if ~isempty(bf.iioDevices{di})
                   testCase.verifyEqual(rvalues{di},values{di});
               end
            end
        end

        function testADAR3002LongsPeakDownCnvLOFreqHz(testCase)
            % Test Down Converter LO Frequency
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([1635 2115], [1 2])*1e7;
            bf.LOFreqHz = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('lo_freq_hz',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvMuxSel(testCase)
            % Test Down Converter MUX Select
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([0 4], [1 2]);
            bf.MuxSel = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    tmp = getDeviceAttributeRAW(bf,'mux_sel',128,bf.DownCnvDevices{k});
                    if strcmp('LOW',tmp)
                        rvalues(:,k) = 0;
                    elseif strcmp('LOCK_DTCT',tmp)
                        rvalues(:,k) = 1;
                    elseif strcmp('R_COUNTER_PER_2',tmp)
                        rvalues(:,k) = 2;
                    elseif strcmp('N_COUNTER_PER_2',tmp)
                        rvalues(:,k) = 3;
                    elseif strcmp('HIGH',tmp)
                        rvalues(:,k) = 4;
                    end
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvNCounterFracVal(testCase)
            % Test Down Converter N-Counter Frac Val
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([0 16777215], [1 2]);
            bf.NCounterFracVal = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('n_counter_frac_val',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end
        
        function testADAR3002LongsPeakDownCnvNCounterIntVal(testCase)
            % Test Down Converter N-Counter Int Val
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([75 65535], [1 2]);
            bf.NCounterIntVal = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('n_counter_int_val',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvNCounterModVal(testCase)
            % Test Down Converter N-Counter Mod Val
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([1 16777215], [1 2]);
            bf.NCounterModVal = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('n_counter_mod_val',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvPFDFreqHz(testCase)
            % Test Down Converter PFD Frequency
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([1 5], [1 2])*1e7;
            bf.PFDFreqHz = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('pfd_freq_hz',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvRefDivBy2(testCase)
            % Test Down Converter Ref Divide by 2
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([0 1], [1 2]);
            bf.RefDivBy2 = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    tmp = getDeviceAttributeRAW(bf,'ref_divide_by_2',128,bf.DownCnvDevices{k});
                    if strcmp('disabled',tmp)
                        rvalues(:,k) = 0;
                    elseif strcmp('enabled',tmp)
                        rvalues(:,k) = 1;
                    end
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvRefDivider(testCase)
            % Test Down Converter Ref Divider
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([1 1023], [1 2]);
            bf.RefDivider = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('ref_divider',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvRefDoubler(testCase)
            % Test Down Converter Ref Doubler
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([0 1], [1 2]);
            bf.RefDoubler = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    tmp = getDeviceAttributeRAW(bf,'ref_doubler',128,bf.DownCnvDevices{k});
                    if strcmp('disabled',tmp)
                        rvalues(:,k) = 0;
                    elseif strcmp('enabled',tmp)
                        rvalues(:,k) = 1;
                    end
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvRefFreqHz(testCase)
            % Test Down Converter Ref Frequency
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([1 5], [1 2])*1e7;
            bf.RefFreqHz = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('ref_freq_hz',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakDownCnvVCOFreqHz(testCase)
            % Test Down Converter VCO Frequency
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([8375 10575], [1 2])*1e6;
            bf.VCOFreqHz = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.DownCnvDevices{k})
                    rvalues(k) = bf.getDeviceAttributeLongLong('vco_freq_hz',...
                        bf.DownCnvDevices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.DownCnvDevices)
               if ~isempty(bf.DownCnvDevices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakADL5240Gain(testCase)
            % Test Down Converter VCO Frequency
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([-63 -1], [1 2])*0.5;
            bf.ADL5240Gain = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.ADL5240Devices{k})
                    rvalues(k) = bf.getAttributeDouble('voltage0',...
                        'hardwaregain',true,bf.ADL5240Devices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.ADL5240Devices)
               if ~isempty(bf.ADL5240Devices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end

        function testADAR3002LongsPeakADRF5720Gain(testCase)
            % Test Down Converter VCO Frequency
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();

            values = randi([-126 -2], [1 2])*0.25;
            bf.ADRF5720Gain = values;
            % Check
            rvalues = zeros(1,2);
            for k=1:2
                if ~isempty(bf.ADRF5720Devices{k})
                    rvalues(k) = bf.getAttributeDouble('voltage0',...
                        'hardwaregain',true,bf.ADRF5720Devices{k});
                end
            end
            bf.release();

            for di = 1:length(bf.ADRF5720Devices)
               if ~isempty(bf.ADRF5720Devices{di})
                   testCase.verifyEqual(rvalues(di),values(di));
               end
            end
        end
        
        function testADAR3002Beams(testCase,beam_props)
            % Beam configurations
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();
            values = randi([1,4],64,4);
            attrs = [0,0,0,0]; % Data not important
            values = testCase.clearUnavailableBeams(attrs,values,...
                bf.iioDevices);
            set(bf,beam_props{1},values);
            % Check
            attrs = beam_props{2};
            rvalues = bf.getAllSingleDevAttrs(attrs,bf.iioDevices);
            bf.release();
            testCase.verifyEqual(rvalues,values);
        end
        
        function testADAR3002BeamsStr(testCase,beam_props_str)
            % Beam configurations
            bf = adi.LongsPeak('uri',testCase.uri);
            bf();
            ivalues = randi([1,4],64,4);
            values = cell(64,4);
            options = {'direct','memory','fifo','instant_direct','reset','mute'};
            for k=1:4
                for g=1:64
                    values{g,k} = options{ivalues(g,k)};
                end
            end
            attrs = [0,0,0,0]; % Data not important
            values = testCase.clearUnavailableBeams(attrs,values,...
                bf.iioDevices);
            set(bf,beam_props_str{1},values);
            % Check
            attrs = beam_props_str{2};
            rvalues = bf.getAllSingleDevAttrs(attrs,bf.iioDevices,'str');
            bf.release();
            testCase.verifyEqual(rvalues,values);
        end
    end
    
end

