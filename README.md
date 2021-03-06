# docker-env-django-projects
Dockerized devel environment for python projects using **django** framework and **postgresql**. **Travis** ready!

## 1. Steps
* Edit the file **requirements.txt** with the python libraries required by your project. 
* Run the command: `docker-compose build`
* Create the django project structure with the command: `docker-compose run app sh -c "django-admin.py startproject PROJECT_NAME ."` (*)
* Create the django core app(**): `docker-compose run app sh -c "python manage.py startapp core"`
* Remove **tests.py** file at core folder, and create  **tests/__init__.py** file. This folder will contain all the tests.

**Note:** change `PROJECT_NAME` with the name of your project
**Note \*\*:** Remember add the new app to `INSTALLED_APPS` list in the **settings.py** file of the project 

At this point, the folder `src` will contain the files of the django project created.

## 2. Postgres 
Once your django project is created, you must config postgres as a database system:

* Edit de project file **settings.py**
* Look for the `DATABASES` block config and write:

`DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'HOST': os.environ.get('DB_HOST'),
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASS'),
    }
}`

To prevent django from trying to connect to Postgres before it is fully up execute: 
* `mkdir -p src/core/management/commands`
* `touch src/core/management/__init__.py src/core/management/commands/__init__.py`
* `cp config/django_tools/wait_for_db.py src/core/management/commands/wait_for_db.py`

Finally, execute `docker-compose build` and `docker-compose stop && docker-compose up`. 

**Note**: If you get ` django.db.utils.OperationalError: could not translate host name "db" to address: Name does not resolve` execute `docker system prune` and `docker-compose up`

**Note**: Port 5432 is exposed






## 3. Travis Integration
* Go to Travis-ci.com and Sign up with GitHub.
* Accept the Authorization of Travis CI. You’ll be redirected to GitHub.
* Click on your profile picture in the top right of your Travis Dashboard, click Settings and then the green Activate button, and select the repository you want to use with Travis CI.

**.travis.yml** contains a minimal configuration. Edit it with your requirements.

After each git push to github, check the build status page to see if your build passes or fails according to the return status of the build command by visiting Travis CI and selecting your repository.


## 4. PyCharm integration

### 4.1 Configuring Docker as a remote interpreter

Make sure that the Docker plugin is enabled. The plugin is bundled with PyCharm and is activated by default. If the plugin is not activated, enable it on the Plugins page of the Settings/Preferences dialog Ctrl+Alt+S as described in Manage plugins.

If you are using Docker for Windows, enable the **Expose daemon on tcp://localhost:2375 without TLS option** in the **General** section of your Docker settings.

Open the **Add Python Interpreter** dialog:
* Go to **File/Settings** menu. 
* Select **Project \<project name>** and inside **Project Interpreter**
* Click de **...** or the **gear icon** and select **Add**
* Select **Docker** from the list on the left. Click on the **NEW...** button on the top right corner and a new dialog will appear

* Write a **name** for the new interpreter
* Select **TCP socket** and wait to see the message **Connection successfull**. 
* Click **OK** to close the dialog.

* Select from the dropdown list **Project interpreter** the recently added **Remote Python Docker interpreter**
* Click the **icon folder** at **Path mappings** and add a new path map
* Click de **icon folder** on **Local Path* column and select the **src folder** of the project
* At the **Remote Path** field add **/** and click **OK**
* Click **APPLY** in the **Settings** dialog and **OK** to close it

  
#### 4.2 Adjust the project path 

Our project files will be inside the **src** and we need adjust that folder to be recognized by PyCharm as source root:

* Select that folder and display the context menu with the secondary button of the mouse
* Go to **Mark directory as** and select **Sources root**

Now PyCharm will recognize the packages and modules of the project correctly



## Useful commands

Run tests: `docker-compose run app sh -c "python manage.py test"` 

Create django project apps:  `docker-compose run app sh -c "python manage.py startapp APP_NAME"`
    
Create django superuser: `docker-compose run app sh -c "python manage.py createsuperuser"`   