clc, clear;
video = false;
jpg_files=dir('c*.jpg');
if video
aviobj = VideoWriter('jump.avi','Uncompressed AVI');
aviobj.FrameRate = 25;
open(aviobj);
end

for k = 1: length(jpg_files)
[pathstr,name,ext] = fileparts(jpg_files(k).name);
RGB = imread(jpg_files(k).name);
I = rgb2gray(RGB);
figure(1),imshow(I), hold on;
[level EM] = graythresh(I);
bw = im2bw(I,EM - .2);
bw = medfilt2(bw,[1 1]);
bw = bwareaopen(bw,2);
bw(205:215,430:440)=0;
cg = regionprops(bw, 'centroid');
cg_centroids = cat(1, cg.Centroid);
cg_centroids= sortrows(cg_centroids,2);
plot(cg_centroids(:,1), ... 
    cg_centroids(:,2), ... 'r+',
    'LineWidth',2, 'MarkerSize',10);
renk = 'ygbr';

for i = 1 : 4
text(cg_centroids(i,1)+30,cg_centroids(i,2),...
sprintf('%3.3f,%3.3f', ...
cg_centroids(i,1), ...
cg_centroids(i,2)), ...
'Color', renk(i), 'FontSize',12);
end

if video
frame = getframe(gcf);
writeVideo(aviobj, frame);
end
hold off
end
if video
close(aviobj);
end