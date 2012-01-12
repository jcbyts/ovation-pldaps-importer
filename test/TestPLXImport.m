classdef TestPLXImport < TestPldapsBase
    
    properties
        pdsFile
        plxFile
        epochGroup
        trialFunctionName
        timezone
    end
    
    methods
        function self = TestPLXImport(name)
            self = self@TestPldapsBase(name);
            
            import ovation.*;
           
            % N.B. these value should match those in runtestsuite
            self.pdsFile = 'fixtures/pat120811a_decision2_16.PDS';
            self.plxFile = 'fixtures/pat120811a_decision2_1600matlabfriendlyPLX.mat';
            self.trialFunctionName = 'trial_function_name';
            self.timezone = 'America/New_York';
            
            
            % Import the plx file
            %ImportPladpsPlx(self.epochGroup,...
            %   self.plxFile);
        end
        
        function setUp(self)
           setUp@TestPldapsBase(self);
           
           %TODO remove for real testing
           itr = self.context.query('EpochGroup', 'true');
           self.epochGroup = itr.next();
           assertFalse(itr.hasNext());
        end
        
        % These are for plx import
        %  - should have spike times t0 < ts <= end_trial
        %  - should have same number of wave forms
        
        
        function testFindEpochGivesNullForNullEpochGroup(~)
            assertTrue(isempty(findEpochByUniqueNumber([], [1,2])));
        end
        
        function testGivesEmptyForNoMatchingEpochByUniqueNumber(self)
            assertTrue(isempty(findEpochByUniqueNumber(self.epochGroup, [1,2,3,4,5,6])));
        end
        
        function testFindsMatchingEpochFromUniqueNumber(self)
            plxStruct = load(self.plxFile);
            plx = plxStruct.plx;
            
            idx = find(plx.unique_number(:,1) ~= 0);
            
            unum = plx.unique_number(idx(1));
            
            epoch = findEpochByUniqueNumber(self.epochGroup, unum);
            
            epochUnum = epoch.getMyProperty('uniqueNumber').getIntegerData();
            assertEquals(mod(epochUnum, 256), unum);
        end
        
        function testShouldHaveSpikeTimesForEachUnit(self)
            
        end
        
        function testSpikeTimeShouldBeInEpochTimeRange(self)
            
        end
        
        function testShouldHaveSameNumberOfSpikesAndWaveForms(self)
            
        end
    end
end