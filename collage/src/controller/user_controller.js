import {
  auth,
  comparePassword,
  genaratetoken,
  genPassword,
} from "../middleware/auth.js";
import UploadImage from "../middleware/cloudinary.js";
import con from "../middleware/db.js";
import {
  CHANGEFIRSTNAME,
  CHANGELASTNAME,
  CHANGEPASSWORD,
  GETPASSWORD,
  LASTLOGIN,
  LOGIN,
  REGISTER,
  SELECT_PHONE,
  SELECT_PROFILE,
  SELECT_TOKEN,
} from "../model/user.js";
export const Register = async (req, res) => {
  try {
    let { FirstName, LastName, Phone, Password } = req.body;
    if (!FirstName) {
      return res.status(400).json({
        FirstName: "FirstName is require",
      });
    }
    if (!LastName) {
      return res.status(400).json({
        LastName: "LastName is require",
      });
    }
    if (!Phone) {
      return res.status(400).json({
        Phone: "Phone is require",
      });
    }
    if (!Password) {
      return res.status(400).json({
        Password: "Password is require",
      });
    }
    const genpassword = await genPassword(Password);
    const image = await UploadImage(req.body.image);

    const values = [[FirstName, LastName, Phone, genpassword, image]];

    con.query(SELECT_PHONE, req.body.Phone, function (err, result1) {
      if (err) throw err;
      if (result1.length > 0) {
        return res.json({
          message: "Phone is already",
        });
      }
      con.query(REGISTER, [values], function (error, resData) {
        if (error) throw error;
        const token = genaratetoken(resData.insertId);
        return res.json(token);
      });
    });
  } catch (error) {
    console.log(error);
  }
};

export const Login_Controller = async (req, res) => {
  try {
    let { Phone, Password } = req.body;
    if (!Phone) {
      return res.json({
        msg: "Phone is require",
      });
    }
    if (!Password) {
      return res.json({
        msg: "Password is require",
      });
    }
    con.query(LOGIN, [Phone], async function (err, result) {
      if (err) throw err;
      if (result.length <= 0)
        return res.status(500).json({ msg: "Invaild Phone" });
      const checkPassword = await comparePassword(
        Password,
        result[0].USER_Password
      );
      if (!checkPassword)
        return res.status(501).json({ msg: "Invaild Password" });
      const token = genaratetoken(result[0].USER_ID);
      con.query(LASTLOGIN, [result[0].USER_ID], function (err, resData) {
        if (err) throw err;
      });
      return res.status(200).json(token);
    });
  } catch (error) {
    console.log(error);
  }
};
export const SelectUserProfile_Cintroller = (req, res) => {
  try {
    let USER_ID = auth(req.headers["token"]);
    if (USER_ID == "No token" || USER_ID == "Please Login")
      return res.status(500).json({ msg: "Pleast Login" });
    con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
      if (err) throw err;

      if (res1 === undefined || res1.length <= 0) {
        return res.status(501).json("Disnable");
      } else {
        con.query(SELECT_PROFILE, [USER_ID], (error, resData) => {
          if (error) throw error;

          return res.status(200).json(resData[0]);
        });
      }
    });
  } catch (error) {
    console.log(error);
  }
};

export const ChangePassword_Controller = async (req, res) => {
  try {
    let oldPassword = req.body.oldPassword;
    let newPassword = await genPassword(req.body.newPassword);

    if (!oldPassword) {
      return res.json({ msg: "oldPassword is require" });
    }
    if (!newPassword) {
      return res.json({ msg: "newPassword is require" });
    }

    let USER_ID = auth(req.headers["token"]);
    if (USER_ID == "No token" || USER_ID == "Please Login")
      return res.status(500).json({ msg: "Pleast Login" });
    con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
      if (err) throw err;

      if (res1 === undefined || res1.length <= 0) {
        return res.status(501).json("Disnable");
      } else {
        con.query(GETPASSWORD, [USER_ID], async (erro, res2) => {
          if (erro) throw erro;
          const checkPassword = await comparePassword(
            oldPassword,
            res2[0].USER_Password
          );
          if (!checkPassword)
            return res.status(502).json({ msg: "Invaild Password" });
          con.query(CHANGEPASSWORD, [newPassword, USER_ID], (error, res3) => {
            if (error) throw error;
            if (res3.affectedRows == 0) {
              return res.status(503).json({ msg: "Can't Change" });
            } else {
              return res.status(200).json({ msg: "Success" });
            }
          });
        });
      }
    });
  } catch (error) {
    console.log(error);
  }
};
export const ChangeFirstName_Controller = (req, res) => {
  try {
    let newFirstName = req.body.newFirstName;
    if (!newFirstName) {
      return res.json({ msg: "newFirstName is require" });
    }
    let USER_ID = auth(req.headers["token"]);
    if (USER_ID == "No token" || USER_ID == "Please Login")
      return res.status(500).json({ msg: "Pleast Login" });
    con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
      if (err) throw err;

      if (res1 === undefined || res1.length <= 0) {
        return res.status(501).json("Disnable");
      } else {
        con.query(CHANGEFIRSTNAME, [newFirstName, USER_ID], (error, result) => {
          if (error) throw error;
          if (result.changedRows == 0) {
            return res.status(502).json({ msg: "Not Chaange" });
          } else {
            return res.status(200).json({ msg: "Success" });
          }
        });
      }
    });
  } catch (error) {
    console.log(error);
  }
};


export const ChangeLastName_Controller = (req, res) => {
  try {
    let newLastName = req.body.newLastName;
    if (!newLastName) {
      return res.json({ msg: "newFirstName is require" });
    }
    let USER_ID = auth(req.headers["token"]);
    if (USER_ID == "No token" || USER_ID == "Please Login")
      return res.status(500).json({ msg: "Pleast Login" });
    con.query(SELECT_TOKEN, [USER_ID], function (err, res1) {
      if (err) throw err;

      if (res1 === undefined || res1.length <= 0) {
        return res.status(501).json("Disnable");
      } else {
        con.query(CHANGELASTNAME, [newLastName, USER_ID], (error, result) => {
          if (error) throw error;
          if (result.changedRows == 0) {
            return res.status(502).json({ msg: "Not Chaange" });
          } else {
            return res.status(200).json({ msg: "Success" });
          }
        });
      }
    });
  } catch (error) {
    console.log(error);
  }
};
