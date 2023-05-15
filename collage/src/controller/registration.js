import { auth } from '../middleware/auth.js';
import con from '../middleware/db.js'
import { LISTOFREGOSTRATION, REGISTRATION, SEARCHREGISTRATION, SELECTDETAILREGISTRATION } from '../model/registration.js';
import { SELECT_TOKEN } from '../model/user.js';

export const Registration_Controller = async function(req,res){
    try {
        let {DP_ID,DPY_ID,RS_Price} = req.body;
        
        if (!DP_ID) {
          return res.json({msg:"DP_ID is require"})
        }
        if (!DPY_ID) {
          return res.json({msg:"DPY_ID is require"})
        }
        if (!RS_Price) {
            return res.json({msg:"RS_Price is require"})
          }
        let USER_ID = auth(req.headers['token']);
        if (USER_ID == "No token" || USER_ID == "Please Login") return res.status(500).json({ msg: "Pleast Login" })
        con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
            if (err) throw err;
        
            if (res1 === undefined || res1.length <= 0) {
                return res.status(501).json("Disnable");
             
            } else {
                const values = [[USER_ID,DP_ID,DPY_ID,RS_Price]];
                con.query(REGISTRATION,[values],(error,result)=>{
                    if(error) throw error;
                    if (result.affectedRows == 0) {
                        return res.status(502).json({msg:"Insert is field"})
                        
                    }else{
                        return res.status(200).json(result.insertId);
                    }
                });
            }
        })
         

    } catch (error) {
        console.log(error);
    }
}

export const SelectDetailRegistration_Controller = (req,res)=>{
    try {
        let RS_ID = req.body.RS_ID;
        if(!RS_ID){
            return res.json({msg:"RS_ID is require"})
        }
        let USER_ID = auth(req.headers['token']);
        if (USER_ID == "No token" || USER_ID == "Please Login") return res.status(500).json({ msg: "Pleast Login" })
        con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
            if (err) throw err;
        
            if (res1 === undefined || res1.length <= 0) {
                return res.status(501).json("Disnable");
             
            }else{
                con.query(SELECTDETAILREGISTRATION,[RS_ID,USER_ID],(error,result)=>{
                    if(error) throw error;
                    if (result === undefined || result.length <=0) {
                        return res.status(502).json({msg:"Data nound found"})
                        
                    }else{
                        return res.status(200).json(result[0]);
                    }
                })
            }
        });
    } catch (error) {
      console.log(error);  
    }
}

export const ListOfRegistration_Controller = (req,res)=>{
    try {
        
        let USER_ID = auth(req.headers['token']);
        if (USER_ID == "No token" || USER_ID == "Please Login") return res.status(500).json({ msg: "Pleast Login" })
        con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
            if (err) throw err;
        
            if (res1 === undefined || res1.length <= 0) {
                return res.status(501).json("Disnable");
             
            }else{
                con.query(LISTOFREGOSTRATION,[USER_ID],(error,result)=>{
                    if(error) throw error;
                    return res.status(200).json(result);
                })
            }
        });

    } catch (error) {
        console.log(error);
        return res.json({
            msg:"Have error",
            error:error
        })
    }
}

export const SearchRegistration_Controller = (req,res)=>{
    try {
        let RS_ID = req.body.RS_ID;
        if (!RS_ID) {
            return res.json({msg:"RS_ID is require"})
        }
        let USER_ID = auth(req.headers['token']);
        if (USER_ID == "No token" || USER_ID == "Please Login") return res.status(500).json({ msg: "Pleast Login" })
        con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
            if (err) throw err;
        
            if (res1 === undefined || res1.length <= 0) {
                return res.status(501).json("Disnable");
             
            }else{
                con.query(SEARCHREGISTRATION,[USER_ID,RS_ID],(error,result)=>{
                    if(error) throw error;
                    return res.status(200).json(result);
                })
            }
        });

    } catch (error) {
        console.log(error);
        return res.json({
            msg:"Have error",
            error:error
        })
    }
}