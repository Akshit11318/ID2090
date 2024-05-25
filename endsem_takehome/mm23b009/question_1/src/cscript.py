import numpy as np
import random
from PIL import Image, ImageOps
import matplotlib.pyplot as plt
from scipy.interpolate import CubicSpline
from datetime import datetime


class TreeNode:
    def __init__(self, locationX, locationY):
        self.locationX = locationX
        self.locationY = locationY
        self.children = []
        self.parent = None

class RRTAlgorithm:
    def __init__(self, start, goal, numIterations, grid, stepSize):
        self.randomTree = TreeNode(start[0], start[1])
        self.goal = TreeNode(goal[0], goal[1])
        self.nearestNode = None
        self.iterations = min(numIterations, 500)
        self.grid = grid
        self.rho = stepSize
        self.path_distance = 0
        self.nearestDist = 10000
        self.numWaypoints = 0
        self.Waypoints = []

    def addChild(self, locationX, locationY):
        if (locationX == self.goal.locationX and locationY == self.goal.locationY):
            self.nearestNode.children.append(self.goal)
            self.goal.parent = self.nearestNode
        else:
            tempNode = TreeNode(locationX, locationY)
            self.nearestNode.children.append(tempNode)
            tempNode.parent = self.nearestNode

    def sampleAPoint(self):
        while True:
            x = random.randint(0, self.grid.shape[1] - 1)
            y = random.randint(0, self.grid.shape[0] - 1)
            point = np.array([x, y])

        # Check if the sampled point is within the obstacle
            if self.grid[y, x] == 1:
                continue

        # Check if the sampled point is within a certain distance from the obstacle
            min_distance = 10  # Adjust this value to increase the distance from obstacles
            is_far_enough = True
            for dx in range(-min_distance, min_distance + 1):
                for dy in range(-min_distance, min_distance + 1):
                    testPointX = x + dx
                    testPointY = y + dy
                    if 0 <= testPointX < self.grid.shape[1] and 0 <= testPointY < self.grid.shape[0]:
                        if self.grid[testPointY, testPointX] == 1:
                            is_far_enough = False
                            break
                if not is_far_enough:
                    break

            if is_far_enough:
                return point

    def steerToPoint(self, locationStart, locationEnd):
        offset = self.rho * self.unitVector(locationStart, locationEnd)
        point = np.array([locationStart.locationX + offset[0], locationStart.locationY + offset[1]])
        if point[0] >= self.grid.shape[1]:
            point[0] = self.grid.shape[1] - 1
        if point[1] >= self.grid.shape[0]:
            point[1] = self.grid.shape[0] - 1
        return point

    def isInObstacle(self, locationStart, locationEnd):
        u_hat = self.unitVector(locationStart, locationEnd)
        for i in range(self.rho):
            testPointX = int(round(locationStart.locationX + i * u_hat[0]))
            testPointY = int(round(locationStart.locationY + i * u_hat[1]))

            if testPointX < 0 or testPointX >= self.grid.shape[1] or testPointY < 0 or testPointY >= self.grid.shape[0]:
                return True

            if self.grid[testPointY, testPointX] == 1:
                return True
        return False

    def unitVector(self, locationStart, locationEnd):
        v = np.array([locationEnd[0] - locationStart.locationX, locationEnd[1] - locationStart.locationY])
        u_hat = v / np.linalg.norm(v)
        return u_hat

    def findNearest(self, root, point):
        if not root:
            return
        dist = self.distance(root, point)
        if dist <= self.nearestDist:
            self.nearestNode = root
            self.nearestDist = dist
        for child in root.children:
            self.findNearest(child, point)

    def distance(self, node1, point):
        dist = np.sqrt((node1.locationX - point[0])**2 + (node1.locationY - point[1])**2)
        return dist

    def goalFound(self, point):
        if self.distance(self.goal, point) <= self.rho:
            return True
        return False

    def resetNearestValues(self):
        self.nearestNode = None
        self.nearestDist = 10000

    def retraceRRTPath(self, goal):
        if goal.locationX == self.randomTree.locationX and goal.locationY == self.randomTree.locationY:
            return
        self.numWaypoints += 1
        currentPoint = np.array([goal.locationX, goal.locationY])
        self.Waypoints.insert(0, currentPoint)
        self.path_distance += self.rho
        self.retraceRRTPath(goal.parent)


##############'

grid = np.load('cspace.npy')
grid = np.asarray(grid, dtype=int)
goal = np.array([380.0, 60.0])
start = np.array([380.0, 720.0])
numIterations = 20000
stepSize = 100
goalRegion = plt.Circle((goal[0], goal[1]), 50, color='g', fill=False)
startRegion = plt.Circle((start[0], start[1]), 50, color='r', fill=False)

fig = plt.figure("RRT path")
plt.imshow(grid, cmap='binary')
plt.plot(start[0], start[1], 'ro')
plt.plot(goal[0], goal[1], 'go')
ax = fig.gca()
ax.add_patch(goalRegion)
ax.add_patch(startRegion)

rrt = RRTAlgorithm(start, goal, numIterations, grid, stepSize)

for i in range(rrt.iterations):
    rrt.resetNearestValues()
    point = rrt.sampleAPoint()
    rrt.findNearest(rrt.randomTree, point)
    new = rrt.steerToPoint(rrt.nearestNode, point)
    bool = rrt.isInObstacle(rrt.nearestNode, new)
    if not bool:
        rrt.addChild(new[0], new[1])
        plt.pause(0.1)
        plt.plot([rrt.nearestNode.locationX, new[0]], [rrt.nearestNode.locationY, new[1]], 'mo', linestyle='-')
        if rrt.goalFound(new):
            rrt.addChild(goal[0], goal[1])
            # print("Number of Iterations: ", i)
            break

rrt.retraceRRTPath(rrt.goal)
rrt.Waypoints.insert(0, start)
print("Number of waypoints: ", rrt.numWaypoints)

# Plot the initial RRT path
for i in range(len(rrt.Waypoints) - 1):
    plt.plot([rrt.Waypoints[i][0], rrt.Waypoints[i + 1][0]], [rrt.Waypoints[i][1], rrt.Waypoints[i + 1][1]], 'bo', linestyle="--")
    plt.pause(0.01)

# Smooth the path using cubic splines
waypoints = np.array(rrt.Waypoints)
x = waypoints[:, 0]
y = waypoints[:, 1]
t = np.linspace(0, 1, len(waypoints))

cs_x = CubicSpline(t, x)
cs_y = CubicSpline(t, y)

t_smooth = np.linspace(0, 1, 300)
x_smooth = cs_x(t_smooth)
y_smooth = cs_y(t_smooth)

# Plot the smoothed path
plt.plot(x_smooth, y_smooth, 'r-', linewidth=2)
plt.show()
'''
numway = rrt.numWaypoints
# Save the figure with a timestamp
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
filename = f"RRT/tmp/{timestamp}_RRT_{numway}.png"
plt.savefig(filename)
'''
