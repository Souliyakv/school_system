import cloudinary from 'cloudinary';
import dotenv from 'dotenv';
dotenv.config();

cloudinary.config({
    cloud_name:process.env.CLOUDINARY_NAME,
    api_key:process.env.CLOUDINARY_API_KEY,
    api_secret:process.env.CLOUDINARY_API_SECRET
});

const UploadImage = async (img,oldImg)=>{
    try {
        if(!img) return "";

        if (oldImg) {
            const spliturl = oldImg.split("/");
            const img_id = spliturl[spliturl.length - 1].split(".")[0];
            await cloudinary.uploader.destroy(img_id);
        }
        const res_upload = await cloudinary.uploader.upload(img,null,{
            public_id:`${Date.now()}`,
            resource_type:"auto"
        });
        return res_upload.url;
    } catch (error) {
        console.log(error);
        return "";
    }
};

export default UploadImage;