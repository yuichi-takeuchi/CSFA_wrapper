function csfaf_saveToStruct1(obj, filename, flag)
%
%    varname=inputname(1);
% Copyright (c) 2019 Qun Li, 2020 Yuichi Takeuchi

    if nargin <3
        flag=0;
    end

    n=size(obj,2);
    s=cell(1,n);
    for i=1:n
      props = properties(obj(i));
      for p = 1:numel(props)
          s{i}.(props{p})=obj(i).(props{p});
      end
    end
    
  switch flag 
      case 0 %train
          trainModel_cell=s;
          save(filename, 'trainModel_cell','-append');
      case 1 % proj
          projModel_cell=s;
          save(filename, 'projModel_cell','-append');
  end
          
end