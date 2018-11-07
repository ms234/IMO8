clc
% find patient
 targetY = 7.35;
 minX = 118;
 tol = 1.2;
for i = 1:Npatients
%   disp(['current patient is ',num2str(i)]); 
   if sum(abs(log10(SOL(i).y(1,:))-targetY)<tol & SOL(i).x > minX)
       disp(['MATCHED PATIENT ',num2str(i)]);
       initVal = InitW(i,:)
      % suscept = parsAllPats(i,3)
   else
      % disp('no match');
   end
end
