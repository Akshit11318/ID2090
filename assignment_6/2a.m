image_path = 'Lena.png';
image_data = imread(image_path);

image_double = double(image_data);
%edge detection
kernel1 = [-1,-1,-1;-1,8,-1;-1,-1,-1];

%
%kernel2 = 1/16 * [1,2,1;2,4,2;1,2,1];
kernel2 = [-1,-1,-1;-1,9,-1;-1,-1,-1];


[m,n] = size(image_double);

edgedetection_image = zeros(m,n);
guassianblur_image = zeros(m,n);

for i = 2:m-1
    for j = 2:n-1
        neighborhood = image_double(i-1:i+1, j-1:j+1);
        edgedetection_image(i, j) = sum(sum(neighborhood .* kernel1));
    end
end
edgedetection_image = uint8(edgedetection_image);


for i = 2:m-1
    for j = 2:n-1
        neighborhood = image_double(i-1:i+1, j-1:j+1);
        guassianblur_image(i, j) = sum(sum(neighborhood .* kernel2));
    end
end
guassianblur_image = uint8(guassianblur_image);


%figure(1);
%imshow(image_data);
%title('Original');

%figure(2);
%imshow(edgedetection_image);
%title('edge detection');
imwrite(edgedetection_image, "edgedetection.jpg", "jpg", "Compression", "none");

%figure(3);
%imshow(gaussianblur_image);
%title('Gaussian blur');
imwrite(guassianblur_image, "sharp.jpg", "jpg", "Compression", "none");
