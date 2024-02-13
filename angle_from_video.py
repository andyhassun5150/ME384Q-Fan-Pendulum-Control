import cv2
import numpy as np
import matplotlib.pyplot as plt

# Function to calculate angle from two points
def calculate_angle(p1, p2):
    angle_rad = np.arctan2(p2[1] - p1[1], p2[0] - p1[0])
    angle_deg = np.degrees(angle_rad)
    return angle_deg

# Open the video file
video_path = 'IMG_8207 2.mov'
cap = cv2.VideoCapture(video_path)
frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

# Create a window to display the video
cv2.namedWindow('Video', cv2.WINDOW_NORMAL)

# Parameters for Lucas-Kanade optical flow
lk_params = dict(winSize=(15, 15), maxLevel=2, criteria=(cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 10, 0.03))

# Read the first frame
ret, old_frame = cap.read()
old_gray = cv2.cvtColor(old_frame, cv2.COLOR_BGR2GRAY)

# Select initial position of the bolt to track (you may need to adjust this)
p0 = np.array([[frame_width/2, frame_height/4]], dtype=np.float32)

# Lists to store angles and corresponding time
angles = []
time_points = []

while ret:
    # Display the frame
    cv2.imshow('Video', old_frame)

    # Read the next frame
    ret, frame = cap.read()
    
    # Check if the frame is valid
    if not ret:
        break

    frame_gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    p1, st, err = cv2.calcOpticalFlowPyrLK(old_gray, frame_gray, p0, None, **lk_params)

    # If the tracking is successful, update the position of the bolt
    if st[0][0] == 1:
        x, y = p1[0]
        p0 = np.array([[x, y]], dtype=np.float32)

        # Locate the fixed bolt (you may need to adjust these coordinates)
        bolt_fixed = (frame_width/2, frame_height/6)

        # Calculate the angle and append to the lists
        angle = calculate_angle(bolt_fixed, (x, y))
        angles.append(-angle+90)

        # Record the time point
        time_points.append(cap.get(cv2.CAP_PROP_POS_MSEC)/1000)

    # Break the loop if the user presses 'q'
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    # Update the previous frame and points
    old_gray = frame_gray.copy()

# Release the video capture object and close the window
cap.release()
cv2.destroyAllWindows()

# Plot the angle over time
plt.plot(time_points, angles)
plt.xlabel('Time (seconds)')
plt.ylabel('Angle (degrees)')
plt.title('Pendulum Angle Over Time')
plt.xlim(1,5.0)
plt.show()

