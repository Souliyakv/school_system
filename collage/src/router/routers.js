import express from 'express'
import { SelectDepartment_Controller, SelectPrice_Controller, SelectYear_Controller } from '../controller/department_controller.js';
import { ListOfRegistration_Controller, Registration_Controller, SearchRegistration_Controller, SelectDetailRegistration_Controller } from '../controller/registration.js';
import { ChangeFirstName_Controller, ChangeLastName_Controller, ChangePassword_Controller, Login_Controller, Register, SelectUserProfile_Cintroller } from '../controller/user_controller.js';
import { auth } from '../middleware/auth.js';


const router = express.Router();

const user = '/user'

router.post(user+'/register',Register)
router.post(user+'/login',Login_Controller);
router.post(user+'/test',auth);
router.get(user+'/getUserProfile',SelectUserProfile_Cintroller);
router.post(user+'/changePassword',ChangePassword_Controller);
router.post(user+'/ChangeFirstName',ChangeFirstName_Controller);
router.post(user+'/ChangeLastName',ChangeLastName_Controller);

const registration = '/registration';

router.post(registration+'/Addregistration',Registration_Controller);
router.post(registration+'/SelectDetailRegistration',SelectDetailRegistration_Controller);
router.get(registration+'/ListOfRegistration',ListOfRegistration_Controller);
router.post(registration+'/SearchRegistration',SearchRegistration_Controller);

const department='/Department';
router.get(department+'/SelectDepartment',SelectDepartment_Controller);
router.post(department+'/SelectYear',SelectYear_Controller);
router.post(department+'/SelectPrice',SelectPrice_Controller);

export default router;