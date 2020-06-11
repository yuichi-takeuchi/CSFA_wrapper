    function electomef_plotRelativeCsd_dCSFA1(self,l,varargin)
    % modify by Qun (based on plotRelativeCsd, which is non-supervised result plot )
    
      % plot the spectral density normalized accross all factors.
      % This gives the *relative* impact of each factor as a function
      % of frequency.
      p = inputParser;
      p.KeepUnmatched = true;
      addOptional(p,'minFreq',0,@isnumeric);
      addOptional(p,'maxFreq',30,@isnumeric);
      %varargin{:}
      parse(p,varargin{:});
      opts = p.Results;
      
      s = linspace(opts.minFreq,opts.maxFreq,1e3);
      
      UKU = zeros(self.C,self.C,1e3,self.L);
      optsUKU.smallFlag = true;
      optsUKU.block = true;
      for j = 1:self.L
        UKU(:,:,:,j) = self.kernel.LMCkernels{j}.UKU(s,optsUKU);
      end
      UKUnorm = bsxfun(@rdivide,UKU,sum(abs(UKU),4));
      
      GP.spectrumPlots.plotCsd(s,UKUnorm(:,:,:,l),varargin{:})
    end