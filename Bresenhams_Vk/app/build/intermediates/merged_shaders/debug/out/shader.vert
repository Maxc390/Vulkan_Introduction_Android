#version 450

layout(location = 0) out vec3 fragColor;

layout(binding = 0) uniform UniformBufferObject {
    mat4 MVP;
} ubo;

const int maxVertices = 100; // Adjust this based on your needs
vec2 positions[maxVertices];

int numVertices;

void addVertex(vec2 vertex) {
    if (numVertices < maxVertices) {
        positions[numVertices] = vertex;
        numVertices++;
    }
}

void bresenham(vec2 p1, vec2 p2) {
    int x = int(p1.x);
    int y = int(p1.y);
    int dx = int(abs(p2.x - p1.x));
    int dy = int(abs(p2.y - p1.y));
    int sx = int(sign(p2.x - p1.x));
    int sy = int(sign(p2.y - p1.y));
    int err = dx - dy;

    addVertex(vec2(float(x), float(y)));

    for (int i = 0; i < 100; i++) { // Adjust the loop termination condition based on your needs
        int e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x += sx;
        }
        if (e2 < dx) {
            err += dx;
            y += sy;
        }

        addVertex(vec2(float(x), float(y)));

        // Terminate the loop when we reach the ending point
        if (x == int(p2.x) && y == int(p2.y)) {
            break;
        }
    }
}

void main() {
    //initialise the numvertices variable
    numVertices = 0;

    // Add the X and Y axis
    bresenham(vec2(-1.0, 0.0), vec2(1.0, 0.0));
    bresenham(vec2(0.0, -1.0), vec2(0.0, 1.0));

    // Add the line using Bresenham's algorithm
    bresenham(vec2(-0.3, -0.4), vec2(0.5, 0.2));

    // Set gl_Position and fragColor based on the generated vertices
    if (gl_VertexIndex < numVertices) {
        gl_Position = ubo.MVP * vec4(positions[gl_VertexIndex], 0.0, 1.0);
        fragColor = vec3(0.0, 0.0, 1.0); // Blue color
    } else {
        gl_Position = vec4(0.0);
        fragColor = vec3(0.0);
    }
}
