#include <SparkFunLSM6DSO.h>
#include "Wire.h"

int enA = 9;
int in1 = 8;
int in2 = 7;
float dt;
float prev_time;
int des_angle; //degrees
float rdes_angle; //radians
float curr_angle; //degrees
float rcurr_angle; //radians
float raw_angle;
float C_o;
float e;
float sum_e;
float prev_e;
float sum;
float temp;
float omega;
float prev_omega;
float alpha;
float Kp;
float Ki;
float Kd;
float P;
float I;
float D;
float PID;
LSM6DSO myIMU;

void setup() {
  Serial.begin(115200);
  myIMU.begin();
  myIMU.initialize(BASIC_SETTINGS);

  dt = 1.0/1000;
  Kp = 5;
  Ki = 3;
  Kd = .5;
  des_angle = 0;
  curr_angle = 0;
  rdes_angle = des_angle*3.141/180;
  e = des_angle;
  omega = 0;
  C_o = sin(rdes_angle) - rdes_angle*cos(rdes_angle);
  pinMode(enA, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  // Turn off motors - Initial state
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
}

void loop() {
  prev_time = millis();
  raw_angle = 0;
  // taking multiple readings for the accelerometer angle due to noise from motor vibrations
  // this is the angle to determine whether the motor is on the right/left side
  sum = 0;
  for (int i = 0; i < 30; i++){
    sum += myIMU.readFloatAccelX();
  }

  // taking multiple readings for the accelerometer angle due to noise from motor vibrations
  // this is the angle that we are setting as the current angle
  for (int i = 0; i < 10; i++){
    temp = myIMU.readFloatAccelZ() - .02;
    if (raw_angle < temp && acos(temp)*180/3.141 <= 18) {
      raw_angle = temp;
    }
  }
  // more filtering
  if (raw_angle >= 1){raw_angle = 0;}
  else{
    raw_angle = acos(raw_angle)*180/3.141;
  }
  if (raw_angle <= 18.0) {
    curr_angle = raw_angle;
  }

  // PID control calculations
  prev_omega = omega;
  omega = (e-prev_e)/dt;
  alpha = (omega-prev_omega)/dt;

  prev_e = e;
  e = des_angle - curr_angle;
  sum_e += ((e+prev_e)/2) * dt;
  sum_e = constrain(sum_e, -30, 30); // so that error_sum doesn't get too big over time

  P = Kp*e;
  I = Ki*sum_e;
  D = Kd*omega;
  PID = abs(P + I + D); // abs() because fan is only in 1 direction
  PID = constrain(PID, 30, 255);
 
  // Fan only rotates in 1 direction
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);

  // due to fan only rotating in 1 direction
  if (des_angle <= 0 && sum < 0) {
    PID  = 0;
  }

  analogWrite(enA, PID);

  dt = (millis() - prev_time)/1000.0;
}