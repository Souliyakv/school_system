import mysql from 'mysql'
 const con = mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'',
    database:'collage'
 });
 con.connect(function(err){
    if(err) {
        return console.log(err);
    }console.log("My sql connect")
 })

 export default con;
 