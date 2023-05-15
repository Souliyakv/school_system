import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import bcrypt from 'bcryptjs';
import con from '../middleware/db.js'
import { SELECT_TOKEN } from '../model/user.js';

dotenv.config();
const SALT_I = parseInt(process.env.SALT);
const SECRET_KEY = process.env.SECRET_KEY

export const genaratetoken = (resData) => {
    return jwt.sign({ resData }, SECRET_KEY, { expiresIn: '7d' })
}

export const verifyTokens = (token) => {
    const decodeToken = jwt.verify(token, SECRET_KEY, (err, decode) => {
        // if(err) throw err;
        return decode;
    });
    return decodeToken;
}

export const auth = (token) => {
    // const token = req.headers['token'];
    if (!token) return "No token";

    const data = verifyTokens(token);

    if (data == undefined || data.length <= 0) {
        return "Please Login"
    }

    const USER_id = data.resData;
    // console.log(USER_id)
    // let message = '';
    // con.query(SELECT_TOKEN, [USER_id], (err, result) => {
    //     if (err) throw err;
      
    //     if (result === undefined || result.length <= 0) {
    //         message = "Disnable"
    //     } else {
    //         message = result[0].USER_ID
         
    //     }
        
    //     return message;
    // }
    // );
    return USER_id;
}

export const genPassword = async (Password) => {
    const saltHash = await bcrypt.genSalt(SALT_I)
    const hashPassword = await bcrypt.hash(Password, saltHash)
    return hashPassword;
}

export const comparePassword = async (loginPassword, Password) => {
    return await bcrypt.compare(loginPassword, Password);
}