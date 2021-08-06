import numpy as np
import cv2
from flask import Flask, Response, jsonify, render_template
from flask_restful import Resource, Api, reqparse
import os
from matplotlib import pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
import matplotlib.pyplot as plt

app = Flask(__name__)
api = Api(app)

DATA = {
    'places':
        ['rome',
         'london',
         'new york city',
         'los angeles',
         'brisbane',
         'new delhi',
         'beijing',
         'paris',
         'berlin',
         'barcelona']
}

class Places(Resource):
    def get(self):
        # return our data and 200 OK HTTP code
        return {'data': DATA}, 200

    def post(self):
        # parse request arguments
        parser = reqparse.RequestParser()
        parser.add_argument('location', required=True)
        args = parser.parse_args()

        # check if we already have the location in places list
        if args['location'] in DATA['places']:
            # if we do, return 401 bad request
            return {
                'message': f"'{args['location']}' already exists."
            }, 401
        else:
            # otherwise, add the new location to places
            DATA['places'].append(args['location'])
            return {'data': DATA}, 200

    def delete(self):
        # parse request arguments
        parser = reqparse.RequestParser()
        parser.add_argument('location', required=True)
        args = parser.parse_args()

        # check if we have given location in places list
        if args['location'] in DATA['places']:
            # if we do, remove and return data with 200 OK
            DATA['places'].remove(args['location'])
            return {'data': DATA}, 200
        else:
            # if location does not exist in places list return 404 not found
            return {
                'message': f"'{args['location']}' does not exist."
                }, 404

# @app.route("/crack", methods=['GET'])
# def identifyCrackDetect():
#     # read a cracked sample image
#     img = cv2.imread('Input-Set/RoadCrack_02.jpg')

#     # Convert into gray scale
#     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#     # Image processing ( smoothing )
#     # Averaging
#     blur = cv2.blur(gray,(3,3))

#     # Apply logarithmic transform
#     img_log = (np.log(blur+1)/(np.log(1+np.max(blur))))*255

#     # Specify the data type
#     img_log = np.array(img_log,dtype=np.uint8)

#     # Image smoothing: bilateral filter
#     bilateral = cv2.bilateralFilter(img_log, 5, 75, 75)

#     # Canny Edge Detection
#     edges = cv2.Canny(bilateral,100,200)

#     # Morphological Closing Operator
#     kernel = np.ones((5,5),np.uint8)
#     closing = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, kernel)

#     # Create feature detecting method
#     # sift = cv2.xfeatures2d.SIFT_create()
#     # surf = cv2.xfeatures2d.SURF_create()
#     orb = cv2.ORB_create(nfeatures=1500)

#     # Make featured Image
#     keypoints, descriptors = orb.detectAndCompute(closing, None)
#     featuredImg = cv2.drawKeypoints(closing, keypoints, None)

#     # Create an output image
#     cv2.imwrite('Output-Set/CrackDetected-7.jpg', featuredImg)

#     # # Use plot to show original and output image
#     # plt.subplot(121),plt.imshow(img)
#     # plt.title('Original'),plt.xticks([]), plt.yticks([])
#     # plt.subplot(122),plt.imshow(featuredImg,cmap='gray')
#     # plt.title('Output Image'),plt.xticks([]), plt.yticks([])


#     return jsonify(
#     url='Output-Set/CrackDetected-7.jpg'
#     )

@app.route("/", methods=['GET'])
def identifyCrack():
    # read a cracked sample image
    img = cv2.imread('static/Input-Set/Piyush.jpeg')

    # Convert into gray scale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Image processing ( smoothing )
    # Averaging
    blur = cv2.blur(gray,(3,3))

    # Apply logarithmic transform
    img_log = (np.log(blur+1)/(np.log(1+np.max(blur))))*255

    # Specify the data type
    img_log = np.array(img_log,dtype=np.uint8)

    # Image smoothing: bilateral filter
    bilateral = cv2.bilateralFilter(img_log, 5, 75, 75)

    # Canny Edge Detection
    edges = cv2.Canny(bilateral,100,200)

    # Morphological Closing Operator
    kernel = np.ones((5,5),np.uint8)
    closing = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, kernel)

    # Create feature detecting method
    # sift = cv2.xfeatures2d.SIFT_create()
    # surf = cv2.xfeatures2d.SURF_create()
    orb = cv2.ORB_create(nfeatures=1500)

    # Make featured Image
    keypoints, descriptors = orb.detectAndCompute(closing, None)
    featuredImg = cv2.drawKeypoints(closing, keypoints, None)

    # Create an output image
    cv2.imwrite('static/Output-Set/PiyushDetected.jpeg', featuredImg)

    # # Use plot to show original and output image
    # plt.subplot(121),plt.imshow(img)
    # plt.title('Original'),plt.xticks([]), plt.yticks([])
    # plt.subplot(122),plt.imshow(featuredImg,cmap='gray')
    # plt.title('Output Image'),plt.xticks([]), plt.yticks([])
    # plt.show()
    # return '<img src="./Output-Set/CrackDetected-7.jpg">'
    return render_template('crack.html', url1='Input-Set/Piyush.jpeg',  url='Output-Set/PiyushDetected.jpeg')

api.add_resource(Places, '/places')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 5050)))