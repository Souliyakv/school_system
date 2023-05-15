import con from "../middleware/db.js";
import { SELECTDEPAERMENT, SELECTPRICE, SELECTYEAR } from "../model/department.js";
export const SelectDepartment_Controller = (req,res)=>{
    try {
        con.query(SELECTDEPAERMENT,(err,result)=>{
            if(err) throw err;
            if (result === undefined || result.length <= 0) {
                return res.status(500).json({msg:"No data"})
            }else{
                return res.status(200).json(result);
            }
        })
    } catch (error) {
        console.log(error);
    }
}

export const SelectYear_Controller = (req,res)=>{
    try {
        let DP_ID = req.body.DP_ID;
        if (!DP_ID) {
            return res.json({mag:"DP_ID is require"});
        }
        con.query(SELECTYEAR,[DP_ID],(err,result)=>{
            if(err) throw err;
            if (result === undefined || result.length <=0) {
                return res.json({msg:"Not data"})
            }else{
                return res.status(200).json(result);
            }
        })

    } catch (error) {
        console.log(error);
    }
}

export const SelectPrice_Controller = (req,res)=>{
    try {
        let DPY_ID = req.body.DPY_ID;
        if (!DPY_ID) {
            return res.json({msg:"DPY_ID is require"})
        }
        con.query(SELECTPRICE,[DPY_ID],(err,result)=>{
            if(err) throw err;
            if (result === undefined || result.length <=0) {
                return res.json({msg:"Not data"})
            }else{
                return res.status(200).json(result[0].DPY_Price);
            }
        })
    } catch (error) {
        console.log(error);
    }
}