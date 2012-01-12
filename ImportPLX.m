function ImportPLX(epochGroup, plxfile, plexonDevice)
    
    import ovation.*
    
    plxStruct = load('-mat', plxfile);
    plx = plxStruct.plx;

    %TODO: derivationParameters
    derivationParameters = struct2map(struct());
    
    disp('Importing PLX data...');
    idx = find(plx.unique_number(:,1) > 0);
    for i = 1:length(idx)
        disp(['    Epoch ' num2str(i) ' of ' num2str(length(idx))]);
        
        epoch = findEpochByUniqueNumber(epochGroup,...
            plx.unique_number(idx(i),:));
        
        if(isempty(epoch))
            warning('ovation:import:plx:unique_number', 'PLX data appears to contain a unique number not present in the epoch group');
            continue;
        end
       
        if(~isempty(plx.spike_times{idx(i)}))
            spike_times = plx.spike_times{idx(i)};
            [maxChannels,maxUnits] = size(spike_times);
            
            % First channel (row) is unsorted
            for c = 2:maxChannels
                % First unit (column) is unsorted
                for u = 2:maxUnits
                    derivedResponseName = ['spikeTimes_channel_' num2str(c-1) '_unit_' num2str(u-1)];
                    epoch.insertDerivedResponse(derivedResponseName,...
                        NumericData(spike_times{c,u}'),...
                        's',... %times in seconds
                        derivationParameters,...
                        {'time from epoch start'}...
                        );
                end
            end
        end
        
        if(~isempty(plx.spike_waveforms{idx(i)}))
            spike_waveforms = plx.spike_waveforms{idx(i)};
            
            [maxChannels,maxUnits] = size(spike_waveforms);
            
            % First channel (row) is unsorted
            for c = 2:maxChannels
                % First unit (column) is unsorted
                for u = 2:maxUnits
                    derivedResponseName = ['spikeWaveforms_channel_' num2str(c-1) '_unit_' num2str(u-1)];
                    
                    waveformData = spike_waveforms{c,u};
                    data = NumericData(reshape(waveformData, 1, numel(waveformData)),...
                        size(waveformData));
                    
                    epoch.insertDerivedResponse(derivedResponseName,...
                        data,...
                        's',... %times in seconds
                        derivationParameters,...
                        {'time from epoch start'}...
                        );
                end
            end
        end
    end
end