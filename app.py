from tensorflow.keras.models import load_model
import numpy as np
import pandas as pd
from flask import Flask, request, jsonify

# Load the saved model
loaded_model = load_model("D:/College/Major Project/tcn_model.h5")
train_df = pd.read_csv("mitbih_train.csv", header=None)

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    data_point = np.array(data['data_point'])
    data_point = np.expand_dims(data_point, axis=0)  # Add batch dimension

    # Make prediction on the data point
    prediction = loaded_model.predict(data_point)

    # Get the predicted class (assuming it's the class with highest probability)
    predicted_class = np.argmax(prediction)
    
    return jsonify({'predicted_class': int(predicted_class), 'predicted_probabilities': prediction.tolist()})

if __name__ == '__main__':
    app.run()
