function [TTP,censorFlag] = goKaplan(SOL,t0,Npatients)


% parse patients

for i=1:Npatients

    thisPatientTimeline = SOL(i).x;
    thisPatientTumorVolume = SOL(i).y(1,:);
     %   plot(thisPatientTimeline,log10(thisPatientTumorVolume));
    % get time from t0 to progression for each patient
    indxForT0 = find(thisPatientTimeline == t0);
    % use only the first value
    indxForT0 = indxForT0(1);
    initialTuVol = thisPatientTumorVolume(indxForT0);
    % get the target volume for progression
    PDvol = initialTuVol * 1.2; 
    % get time to progression
    indxTTP = find(thisPatientTumorVolume >= PDvol);
    if isempty(indxTTP)
        TTP(i) = max(thisPatientTimeline);
        censorFlag(i) = 1;
    else
        indxTTP = indxTTP(1); % take first occurrence
        TTP(i) = thisPatientTimeline(indxTTP) - t0;
        censorFlag(i) = 0;
    end
end


%goKaplan(SOL,InitW(:,2)./InitW(:,3))