import express from 'express';
import router from './router/routers.js';
import dotenv from 'dotenv';
import cors from 'cors';
import bodyParser from 'body-parser';
import cookieParser from 'cookie-parser';

dotenv.config();
const Port = process.env.PORT;

const app = express();
const api = '/api'
app.use(cors());
app.use(bodyParser.json({extended:false,limit:'5000mb'}));
app.use(bodyParser.urlencoded({extended:false,limit:'5000mb',parameterLimit:50000}));
app.use(cookieParser());
app.use(api,router)

app.listen(Port,()=>{
    console.log(`Server Running on port ${Port}`)
});