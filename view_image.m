function ImageViewer(filename, dataDimensions, voxelsize, viewType, sliceIndex)
    % Input:
    % - filename: Name of the file containing the MRI data.
    % - dataDimensions: 3-element vector specifying [x, y, z] dimensions.
    % - voxelsize: 3-element vector specifying voxel size in [x, y, z].
    % - viewType: 'coronal', 'saggital', or 'axial'.
    % - sliceIndex (optional): The slice to display, defaults to the middle slice if not provided.
    
    % Open and read file
    fin = fopen(filename, 'r', 'l');
    I = fread(fin); 
    fclose(fin);  % Close the file after reading

    % Generate tensor based on the provided data dimensions
    volume = reshape(I, dataDimensions(1), dataDimensions(2), dataDimensions(3));

    % Handle different view types
    switch lower(viewType)
        case 'coronal'
            % Coronal View
            if nargin < 5
                sliceIndex = round(size(volume, 3) / 2);  % Default slice if not provided
            end
            coronal = volume(:, :, sliceIndex);
            coronal = squeeze(coronal);
            coronal = rot90(coronal, -1);  % Rotate 90 degrees clockwise

            % Scale the image based on the voxel sizes (x and y normal, z affected)
            scaleImage(coronal, voxelsize(2), voxelsize(1));

        case 'saggital'
            % Sagittal View
            if nargin < 5
                sliceIndex = round(size(volume, 1) / 2);  % Default slice if not provided
            end
            saggital = volume(sliceIndex, :, :);
            saggital = squeeze(saggital);
            saggital = rot90(saggital, 1);  % Rotate 90 degrees anticlockwise

            % Scale the image based on the voxel sizes (y and z affected)
            scaleImage(saggital, voxelsize(3), voxelsize(2));

        case 'axial'
            % Axial View
            if nargin < 5
                sliceIndex = round(size(volume, 2) / 2);  % Default slice if not provided
            end
            axial = volume(:, sliceIndex, :);
            axial = squeeze(axial);
            axial = rot90(axial, 1);  % Rotate 90 degrees anticlockwise

            % Scale the image based on the voxel sizes (x and z affected)
            scaleImage(axial, voxelsize(3), voxelsize(1));

        otherwise
            disp('Invalid view type. Please choose coronal, saggital, or axial.');
    end
end

function scaleImage(imageData, voxelSizeX, voxelSizeY)
    % Display the image
    image(imageData);

    % Adjust the aspect ratio based on voxel sizes
    axis image;
    % Apply voxel size scaling: X and Y should reflect voxelSizeX and voxelSizeY
    daspect([voxelSizeX voxelSizeY 1]);  % Set the voxel aspect ratio
end

ImageViewer('t1_icbm_normal_5mm_pn0_rf0.rawb', [181,217,36], [1, 1, 5], 'axial')