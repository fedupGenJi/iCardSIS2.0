function GoToStudReg()
{
    window.location.href="/html/StudReg.html";
}



function GoToUpdate(){
    window.location.href="/html/Update.html";
}



// verify popup

function showVerifyPopup() {
    const popup = document.getElementById('verify-popup');
    popup.style.display = 'flex';
}

// Hide the Verify Payment popup
function hideVerifyPopup() {
    const popup = document.getElementById('verify-popup');
    popup.style.display = 'none';
}

// Handle form submission
document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('verify-payment-form');
    form.addEventListener('submit', (event) => {
        event.preventDefault(); // Prevent page reload

        // Extract input values
        const phoneNumber = document.getElementById('phone-number').value;
        const amount = document.getElementById('amount').value;

        // Validate inputs
        if (!phoneNumber || !amount) {
            alert('Please fill in all fields');
            return;
        }

        alert(`Phone Number: ${phoneNumber}\nAmount: ${amount}`);

        form.reset();

        hideVerifyPopup();
    });
});




// Admin details 

function showAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'flex';
}


function hideAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'none';
}



// mobile app query

function showQueryPopup() {
    const popup = document.getElementById('query-popup');
    popup.style.display = 'flex';
}


function hideQueryPopup() {
    const popup = document.getElementById('query-popup');
    popup.style.display = 'none';
}


document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('query-form');
    form.addEventListener('submit', (event) => {
        event.preventDefault(); 

        
        const id = document.getElementById('ID-number').value;
        

       
        if (!id) {
            alert('Please fill in all fields');
            return;
        }
        // if the search is found 
        
        CheckAndGo();
    

        form.reset();

        hideQueryPopup();
    });
});

function CheckAndGo(){

    const id = document.getElementById('ID-number').value;
        
    if(id){
        GoToMainQueryPopup();
    }
}

       
// main query popup
function showMainQueryPopup() {
    const popup = document.getElementById('main-query-popup');
    popup.style.display = 'flex';
}

function hideMainQueryPopup() {
    const popup = document.getElementById('main-query-popup');
    popup.style.display = 'none';
}

function GoToMainQueryPopup()
{
   
    showMainQueryPopup();
    
   
    
    
 
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('main-query-form');
        form.addEventListener('submit', (event) => {
            event.preventDefault(); 
    
            
            const phoneNumber = document.getElementById('phone-number').value;
            const password = document.getElementById('password').value;
    
          
            if (!phoneNumber || !password) {
                alert('Please fill in all fields');
                return;
            }
    
            alert(`Changed Successfully`);
    
            form.reset();
    
            hideMainQueryPopup();
        });
    });


}
