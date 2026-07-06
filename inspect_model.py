from tensorflow.keras.models import load_model

model = load_model('best_model.h5')   # adjust path if needed
print("MODEL SUMMARY")
model.summary()

# Print input shape used by the model (None, H, W, C) usually
try:
    print("Model input shape:", model.input_shape)
except Exception as e:
    print("Cannot get input shape:", e)