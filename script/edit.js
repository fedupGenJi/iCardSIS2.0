function ExtractData(){
    var name=document.getElementById('full-name').value;
    var year=document.getElementById('dob-year').value;
    var month=document.getElementById('dob-month').value;
    var day=document.getElementById('dob-day').value;
    var bloodGroup=document.getElementById('blood-group').value;
    var sex=document.getElementById('sex').value;
    var email=document.getElementById('email').value;
    var course=document.getElementById('course').value;
    var yoe=document.getElementById('enrollment').value;
    var photo=document.getElementById('photo-input').files[0];
    var confirm=document.getElementById('confirm').checked;
   

    

}


function showAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'flex';
}


function hideAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'none';
}