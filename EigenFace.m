classdef EigenFace
    methods(Static)
       
        %face detection and adding face to database
        function result=extractFace(image,dim)%N
            result=[0,0,0];
            faceDetector = vision.CascadeObjectDetector;
            faceCordinates = step(faceDetector, image);
            if size(faceCordinates)~=0 %if faces detected in image is not 0
                i=size(faceCordinates,1);
                result=imcrop(image,faceCordinates(1,:));%extract first image detected
                result=imresize(result,[dim dim]);
                result=rgb2gray(result);
            end
            
        end
        function resultStruct=addImage(image,imagename,struct)
            if (size(struct.names)~=0)
                s=size(struct.names,2);%no of images
            else
                s=0;
            end
            
            if (size(image)>1)%only if there is image (not empty image)
                struct.names(1,s+1)={imagename};
                struct.data{s+1}=image;
            end
            resultStruct=struct;
        end
        
        function saveFaces(filename,structname)
            %save (filename, structname);
            save (filename,'-struct', 'structname');
        end
        
        function resultStruct=loadFaces(filename)
            
            resultStruct=load (filename);
        end
        %END face detection and adding face to database
               
        %Eigen Vectors
        function mean=computeMean(struct)
            mean=0;
            M=size(struct.data,2);
            if (M>0)%sruct is not empty
                N=size(struct.data{1},1);
                mean=zeros(N);
                for i=1:M
                   mean=mean +(1/M)*(im2single(struct.data{i}));
                end 
            end
        end
        
        function resultStruct=normalize(struct)
            
            
        end
    end%END methods
    
    
end