from flask import Flask, render_template, Response, jsonify, request,send_file,stream_with_context
import requests
import cv2
import json
import os
import fnmatch
import time
from datetime import datetime
import time
import numpy as np
import threading

import mysql.connector
from mysql.connector import Error

from io import BytesIO

import serial.tools.list_ports
import serial

import shutil
from flask_cors import CORS
listcamera_use = 0
st_show_image = True
def nothing(x):
    pass
def run_camara_real_time():
    global camera
    global st_show_image
    global listcamera_use
    start_frist = True

    global h_min, h_max, s_min, s_max, v_min, v_max, brightness, contrast, saturation_boost, range_detect
    while True:
        if(st_show_image):
            if(start_frist):
                cv2.namedWindow("Yellow Detection")
                cv2.createTrackbar("Hue Min", "Yellow Detection", 0, 179, nothing)
                cv2.createTrackbar("Hue Max", "Yellow Detection", 0, 179, nothing)
                cv2.createTrackbar("Sat Min", "Yellow Detection", 0, 255, nothing)
                cv2.createTrackbar("Sat Max", "Yellow Detection", 0, 255, nothing)
                cv2.createTrackbar("Val Min", "Yellow Detection", 0, 255, nothing)
                cv2.createTrackbar("Val Max", "Yellow Detection", 0, 255, nothing)
                cv2.createTrackbar("Brightness", "Yellow Detection", 0, 100, nothing)
                cv2.createTrackbar("Contrast", "Yellow Detection", 0, 100, nothing)
                cv2.createTrackbar("Saturation Boost", "Yellow Detection", 0, 10, nothing)
                cv2.createTrackbar("Range", "Yellow Detection", 0, 2000, nothing)
                camera = cv2.VideoCapture(listcamera_use)
                start_frist = False

            success, frame = camera.read()

            h_min = cv2.getTrackbarPos("Hue Min", "Yellow Detection")
            h_max = cv2.getTrackbarPos("Hue Max", "Yellow Detection")
            s_min = cv2.getTrackbarPos("Sat Min", "Yellow Detection")
            s_max = cv2.getTrackbarPos("Sat Max", "Yellow Detection")
            v_min = cv2.getTrackbarPos("Val Min", "Yellow Detection")
            v_max = cv2.getTrackbarPos("Val Max", "Yellow Detection")
            brightness = cv2.getTrackbarPos("Brightness", "Yellow Detection")
            contrast = cv2.getTrackbarPos("Contrast", "Yellow Detection")
            saturation_boost = cv2.getTrackbarPos("Saturation Boost", "Yellow Detection")
            range_detect = cv2.getTrackbarPos("Range", "Yellow Detection")

            if(success):
                brightness_1 = brightness - 50  # ปรับค่าให้เป็น -50 ถึง 50
                contrast_1 = contrast / 50.0  # ปรับค่าให้เป็น 0 ถึง 2.0
                frame = cv2.convertScaleAbs(frame, alpha=contrast_1, beta=brightness_1)

                hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
                hsv[:, :, 1] = np.clip(hsv[:, :, 1] * saturation_boost, 0, 255)
                lower_yellow = np.array([h_min, s_min, v_min])
                upper_yellow = np.array([h_max, s_max, v_max])
                mask = cv2.inRange(hsv, lower_yellow, upper_yellow)
                # Define ROI and process contours
                rect_x1, rect_y1 = 200, 50
                rect_x2, rect_y2 = 450, 450
                contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                for contour in contours:
                    if cv2.contourArea(contour) > range_detect:
                        x, y, w, h = cv2.boundingRect(contour)
                        if x >= rect_x1 and y >= rect_y1 and (x + w) <= rect_x2 and (y + h) <= rect_y2:
                            cv2.drawContours(frame, [contour], -1, (0, 255, 0), 2)
                            calw = x + w
                            calh = y + h
                            cv2.rectangle(frame, (x, y), (calw, calh), (0, 0, 255), 2)
                            frame = cv2.putText(frame, f'P1:{y}', (calw + 10, y), cv2.FONT_HERSHEY_SIMPLEX,
                                                0.5, (0, 255, 0), 1, cv2.LINE_AA)
                            frame = cv2.putText(frame, f'P2:{calh}', (calw + 10, calh), cv2.FONT_HERSHEY_SIMPLEX,
                                                0.5, (0, 255, 0), 1, cv2.LINE_AA)
                            po_w_box = y + int((calh - y) / 2)
                            cal_px = calh - y
                            frame = cv2.putText(frame, f'PW:{cal_px} Px', (calw + 10, po_w_box), cv2.FONT_HERSHEY_SIMPLEX,
                                                0.5, (255, 255, 0), 1, cv2.LINE_AA)
                cv2.rectangle(frame, (rect_x1, rect_y1), (rect_x2, rect_y2), (255, 0, 0), 5)
                cv2.imshow("Yellow Detection mask",mask)
                cv2.imshow("Yellow Detection",frame)
                cv2.waitKey(1)
        else:
            cv2.destroyAllWindows()
            camera.release()
            start_frist = True

run_camara_real_time()