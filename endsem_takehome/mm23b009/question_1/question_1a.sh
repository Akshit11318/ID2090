#!/usr/bin/bash
# Change directory to src/
cd src

# Path to the source directory
SRC_DIR="."

# Check if src directory exists
if [ -d "$SRC_DIR" ]; then
    # Run RRT.py in the background
    if [ -f "$SRC_DIR/RRT.py" ]; then
        echo "Running RRT.py"
        python3 "$SRC_DIR/RRT.py" &
    else
        echo "Error: RRT.py not found in $SRC_DIR directory."
        exit 1
    fi
    # Wait for 5 seconds
    sleep 6 
    
    # Run gRRT.py in the background
    if [ -f "$SRC_DIR/gRRT.py" ]; then
        echo "Running gRRT.py"
        python3 "$SRC_DIR/gRRT.py" &
    else
        echo "Error: gRRT.py not found in $SRC_DIR directory."
        exit 1
    fi

    # Wait for both background processes to finish
    wait

    # Change directory back to the original one
    cd ..

else
    echo "Error: $SRC_DIR directory not found."
    exit 1
fi
