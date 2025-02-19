from flask import Flask, render_template,url_for

app=Flask(__name__)

admin_details={

    "admin_name":'Test Narayan',
    "admin_position":'Librarian',
    "admin_id":'2025',
    "admin_photo_url":None,
    "admin_email":'testnarayan@gmail.com',
    "admin_status":'Librarian'
    }

bookshelves=[
                    {'id':'1','name':'HELLO WORLD','number':'20'},
                    {'id':'2','name':'HI HUMAN','number':'2'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'3','name':'BYE WORLD','number':'40'},
                    {'id':'4','name':'BYE HUMAN','number':'40'}
            ]
    
    



@app.route('/')
def lib_menu():
    admin_details['admin_photo_url']=url_for('static',filename='assests/icons/admin.jpg')
    return render_template('lib_menu.html',admin_details=admin_details)



@app.route('/bookshelf')
def bookshelf():
    admin_details['admin_photo_url']=url_for('static',filename='assests/icons/admin.jpg')
    print(bookshelves)
    return render_template('bookshelf.html',admin_details=admin_details,bookshelves=bookshelves)



if __name__=='__main__':
    app.run(debug=True,port=1000)