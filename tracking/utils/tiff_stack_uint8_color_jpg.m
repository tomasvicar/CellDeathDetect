function tiff_stack_uint8_color_jpg(nazev,data,k)
data=uint8(data);

%  Modify these variables to reuse this section: (enclosed by ----s)
%     - outputFileName  (filename in your question)
%     - data            (Id{k} in your question)
%



outputFileName = nazev;
% This is a direct interface to libtiff
if k==1
    t = Tiff(outputFileName,'w');
%       imwrite(data,nazev,'WriteMode','overwrite')
else
    t = Tiff(outputFileName,'a');
%       imwrite(data,nazev,'WriteMode','append')
    
end


% 
t.setTag('Photometric',Tiff.Photometric.YCbCr);
t.setTag('Compression',Tiff.Compression.JPEG);
t.setTag('YCbCrSubSampling',[2 2]);
t.setTag('BitsPerSample',8);
t.setTag('SamplesPerPixel',3);
t.setTag('SampleFormat',Tiff.SampleFormat.UInt);
t.setTag('ImageLength',size(data,1));
t.setTag('ImageWidth',size(data,2));
t.setTag('TileLength',32);
t.setTag('TileWidth',32);
t.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
t.setTag('JPEGColorMode',Tiff.JPEGColorMode.RGB);
t.setTag('JPEGQuality',90);

t.write(data);
t.close();








