
import tkinter as tk
from tkinter.filedialog import askopenfilename
import tkinter as tk
import copy

J={"signal":"","noise":""}

# root.mainloop()

D=["frequncy encoding","phase enoding"]

from mroptimum.mro import SNR,RECON

import tkinter as tk
from tkinter import filedialog

def show_file_content():
    filename1 = tk.filedialog.askopenfile(title="Signal File")
    filename2 = tk.filedialog.askopenfile(title="Noise File", initialdir=".") if not LL.get() else None
    global J
    J["signal"]=filename1.name
    if filename2 is None:
        J["noise"]=filename1.name
    else:
        J["noise"]=filename2.name
    panel2.grid(row=4, column=0, columnspan=2)
    

def finalize_choice():
    # print(file1.get(), file2.get())
    root.quit()

root = tk.Tk()
root.title("generate")

LL=tk.BooleanVar(root)
panel = tk.LabelFrame(root, text="Signal")
panel.grid(row=3, column=0, columnspan=2)

checkbutton = tk.Checkbutton(panel, text="Use MultiRaid Noise",variable=LL)
checkbutton.grid(row=0, column=0)


button = tk.Button(panel, text="Select files", command=show_file_content)
button.grid(row=2, column=0)


panel2 = tk.LabelFrame(root, text="SNR Method")
panel2.grid_remove()


# Variable to keep track of the option
# selected in OptionMenu
value_inside = tk.StringVar(root)
  
# Set the default value of the variable
value_inside.set("Select an Option")
  
# Create the optionmenu widget and passing 
# the options_list and value_inside to it.
question_menu = tk.OptionMenu(panel2, value_inside, *SNR)
question_menu.grid(row=0, column=0)



def print_answers():
    global J
    J["type"]=value_inside.get()
    panel3.grid()
  
# Submit button
# Whenever we click the submit button, our submitted
# option is printed ---Testing purpose
submit_button = tk.Button(panel2, text='Submit', command=print_answers)
submit_button.grid(row=1,column=0)




panel3 = tk.LabelFrame(root, text="Reconstruction Method")
panel3.grid_remove()


# Variable to keep track of the option
# selected in OptionMenu
recon_inside = tk.StringVar(root)
  
# Set the default value of the variable
recon_inside.set("Select an Option")
  
# Create the optionmenu widget and passing 
# the options_list and value_inside to it.
question_menu2 = tk.OptionMenu(panel3, recon_inside, *RECON)
question_menu2.grid(row=0, column=0)



def print_answers2():
    global J
    J["recon"]=recon_inside.get()
    panel_mimic.grid()
  
# Submit button
# Whenever we click the submit button, our submitted
# option is printed ---Testing purpose
submit_button2 = tk.Button(panel3, text='Submit', command=print_answers2)
submit_button2.grid(row=1,column=0)

def mimic():
    
    if ((LL2.get()) and (J["recon"] != 'rss') and  (J["recon"] != 'b1')):
        panel_accelerations.grid()
        if (J["recon"].lower()=='grappa'):
            panel_acl.grid()

panel_mimic = tk.LabelFrame(root, text="Mimic Accelration")
panel_mimic.grid_remove()

LL2=tk.BooleanVar(root)
checkbutton2 = tk.Checkbutton(panel_mimic, text="Mimic Acceleration",variable=LL2)
checkbutton2.grid(row=0, column=0)


submit_button3 = tk.Button(panel_mimic, text='contnue', command=mimic)
submit_button3.grid(row=1,column=0)

def set_accelerations():
    global J
    x_acceleration = int(entry_x.get())
    y_acceleration = int(entry_y.get())
    J["mimic"]=True
    J["accelrattion"]=[x_acceleration, y_acceleration]
    print("Accelerations set to: x = {}, y = {}".format(x_acceleration, y_acceleration))

def set_acl():
    x_acl = int(entry_x_acl.get())
    y_acl = int(entry_y_acl.get())
    J["mimic"]=True
    J["accelrattion"]=[x_acl, y_acl]
    print("ACL set to: x = {}, y = {}".format(x_acl, y_acl))


panel_accelerations = tk.LabelFrame(root, text="Accelerations")
panel_accelerations.grid_remove()

label_x = tk.Label(panel_accelerations, text="X acceleration")
label_x.grid(row=0, column=0)

entry_x = tk.Entry(panel_accelerations)
entry_x.grid(row=0, column=1)

label_y = tk.Label(panel_accelerations, text="Y acceleration")
label_y.grid(row=1, column=0)

entry_y = tk.Entry(panel_accelerations)
entry_y.grid(row=1, column=1)

button_set_accelerations = tk.Button(panel_accelerations, text="Set accelerations", command=set_accelerations)
button_set_accelerations.grid(row=2, column=0)

panel_acl = tk.LabelFrame(root, text="ACL")
panel_acl.grid_remove()

label_x_acl = tk.Label(panel_acl, text="X ACL")
label_x_acl.grid(row=0, column=0)

entry_x_acl = tk.Entry(panel_acl)
entry_x_acl.grid(row=0, column=1)

label_y_acl = tk.Label(panel_acl, text="Y ACL")
label_y_acl.grid(row=1, column=0)

entry_y_acl = tk.Entry(panel_acl)
entry_y_acl.grid(row=1, column=1)

button_set_acl = tk.Button(panel_acl, text="Set ACL", command=set_acl)
button_set_acl.grid(row=2, column=0)



root.mainloop()

print(J)


