function tiff_stack_uint8(nazev,data,k)
data=uint8(data);

%  Modify these variables to reuse this section: (enclosed by ----s)
%     - outputFileName  (filename in your question)
%     - data            (Id{k} in your question)
%



% outputFileName = nazev;
% This is a direct interface to libtiff
if k==1
%     t = Tiff(outputFileName,'w');
      imwrite(data,nazev,'WriteMode','overwrite')
else
%     t = Tiff(outputFileName,'a');
      imwrite(data,nazev,'WriteMode','append')
    
end


% 
% tagstruct.ImageLength     = size(data,1);
% tagstruct.ImageWidth      = size(data,2);
% tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
% tagstruct.BitsPerSample   = 32;
% tagstruct.SamplesPerPixel = 1;
% tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
% tagstruct.RowsPerStrip    = 16;
% tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% tagstruct.Software        = 'MATLAB';
% t.setTag(tagstruct)
% 
% t.write(data);
% t.close();








