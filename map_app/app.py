from flask import Flask, render_template,request
from flask_googlemaps import GoogleMaps
from flask_googlemaps import Map

app = Flask(__name__)
GoogleMaps(app)


def delete_file():
    if os.path.isfile("/Users/amirulislam/Downloads/lat.txt"):
        os.remove("/Users/amirulislam/Downloads/lat.txt")    

    if os.path.isfile("/Users/amirulislam/Downloads/lon.txt"):
        os.remove("/Users/amirulislam/Downloads/lon.txt")

    if os.path.isfile("/Users/amirulislam/Downloads/sos_msg.txt"):
        os.remove("/Users/amirulislam/Downloads/sos_msg.txt")

def write_to_file(file_name,data):
    f= open(file_name,"w+")
    f.write(str(data))
    f.close()





# @app.route("/mapit",methods=['POST'])
@app.route("/storesos",methods=['POST'])
def storesos():
	
	print(request.form)
	sos_msg=request.form["sos_msg"]
	lat=request.form["lat"]
	lon=request.form["lon"]
	# for key,val in request.form.items():
	# 	print(key,val)
	# list_args=request.form[0]
	# print(list_args)
	# sos_msg=list_args[0][1]
	# print(sos_msg)

	# print(request.is_json)
	# content = request.get_json()
	# print (content)

	location="/Users/amirulislam/Downloads/"
	for key,val in request.form.items():
		print("writing to ",location+key,val)
		write_to_file(location+key,val)

	return "Success"

def read_from_file(file_name):
    f= open(file_name,"r+")
    contents =f.read()
    f.close()
    return contents


@app.route("/mapsos")
def mapsos():
	location="/Users/amirulislam/Downloads/"
	lat=read_from_file(location+"lat")
	lon=read_from_file(location+"lon")
	sos_msg=read_from_file(location+"sos_msg")


	



	# creating a map in the view
	mymap = Map(
	identifier="view-side",
	lat=lat,
	lng=lon,
	markers=[(lat, lon)]
	)
	sndmap = Map(
	identifier="sndmap",
	lat=lat,
	lng=lon,
	markers=[
	{
	'icon': 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
	'lat': lat,
	'lng': lon,
	'infobox': "<b>"+sos_msg+"</b>"
	}
	# ,
	# {
	# 'icon': 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png',
	# 'lat': 37.4300,
	# 'lng': -122.1400,
	# 'infobox': "<b>Hello World from other place</b>"
	# }
	]
	)
	return render_template('index.html', mymap=mymap, sndmap=sndmap)

if __name__ == "__main__":
	app.run(debug=True,host='0.0.0.0',port=5001)