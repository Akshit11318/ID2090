
image_path = 'Noisy_Lena.png';
image_data = imread(image_path);

image_double = double(image_data);

kernel2 = 1/16 * [1,2,1;2,4,2;1,2,1];

[m,n] = size(image_double);

guassianblur_image = zeros(m,n);

for i = 2:m-1
    for j = 2:n-1
        neighborhood = image_double(i-1:i+1, j-1:j+1);
        guassianblur_image(i, j) = sum(sum(neighborhood .* kernel2));
    end
end

for i = 2:m-1
    for j = 2:n-1
        neighborhood = image_double(i-1:i+1, j-1:j+1);
        guassianblur_image(i, j) = sum(sum(neighborhood .* kernel2));
    end
end

for i = 2:m-1
    for j = 2:n-1
        neighborhood = image_double(i-1:i+1, j-1:j+1);
        guassianblur_image(i, j) = sum(sum(neighborhood .* kernel2));
    end
end


guassianblur_image = uint8(guassianblur_image);

imwrite(guassianblur_image, "gaussianblur_image.png", "png", "Compression", "none");
