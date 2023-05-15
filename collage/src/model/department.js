export const SELECTDEPAERMENT = `SELECT DP_Name,DP_ID FROM department`
export const SELECTYEAR = `SELECT department.Dp_desc,dp_year.DPY_Year,dp_year.DPY_ID FROM department INNER JOIN dp_year on department.DP_ID=dp_year.DP_ID where dp_year.DP_ID=?`;
export const SELECTPRICE = `SELECT DPY_Price FROM dp_year WHERE DPY_ID=?`;