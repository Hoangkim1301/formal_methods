mtype = {RED, YELLOW, GREEN}; //traffic light states
mtype pedestrian = {RED, GREEN}; //pedestrian light states


chan pedestrian[4] = [0] of {mtype};
chan traffic_light[4] = [0] of {mtype};

active proctype PedestrianLight(byte id){
    mtype state = Red;  // Initial state: Red

    do
    :: state == Red ->  // Wait for button press
        :: (id == 0 && button0?) -> state = Green
        :: (id == 1 && button1?) -> state = Green
        :: (id == 2 && button2?) -> state = Green
        :: (id == 3 && button3?) -> state = Green
    :: state == Green ->  // Stay Green until button released
        :: (id == 0 && button0?) -> skip
        :: (id == 1 && button1?) -> skip
        :: (id == 2 && button2?) -> skip
        :: (id == 3 && button3?) -> skip
        :: button_release -> state = Red
    od
}

proctype traffic_light(chan button) {
    mtype state = Red;  // Initial state: Red

    do
    :: state == Red -> state = RedYellow;  // Red to Red-Yellow
    :: state == RedYellow -> state = Green;  // Red-Yellow to Green
    :: state == Green -> state = Yellow;  // Green to Yellow
    :: state == Yellow -> state = Red;  // Yellow to Red
    od
}