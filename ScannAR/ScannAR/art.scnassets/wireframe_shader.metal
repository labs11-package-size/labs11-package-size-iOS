//Copyright © 2018 Apple Inc.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/*
Abstract:
SceneKit shader modifier to render bounding box edges with distance-based fade.
*/
#pragma transparent
#pragma body

float3 modelPosition = scn_node.modelTransform[3].xyz;
float3 viewPosition = scn_frame.inverseViewTransform[3].xyz;
float distance = length(modelPosition - viewPosition);

float3 bBoxMin = scn_node.boundingBox[0];
float3 bBoxMax = scn_node.boundingBox[1];
float3 size = bBoxMax - bBoxMin;
float bBoxDiag = length(size);

////////////////////////////////////////////////////////////////
// Compute per-pixel transparency based on distance from camera
////////////////////////////////////////////////////////////////
float closest = distance - bBoxDiag / 2.0;
float furthest = distance + bBoxDiag / 2.0;
float distFromPointOfView = length(_surface.position);
float normalizedDistance = 1 - ((distFromPointOfView - closest) / (furthest - closest));
_surface.transparent.a = clamp(normalizedDistance, 0.0, 1.0);

////////////////////////////////////////////////////////////////
// Render only a wireframe
////////////////////////////////////////////////////////////////
float lineThickness = 0.002;
float u = _surface.diffuseTexcoord.x;
float v = _surface.diffuseTexcoord.y;

// Compute scaling of line thickness based on bounding box size
float2 scale;
if (abs((scn_node.inverseModelViewTransform * float4(_surface.normal, 0.0)).x) > 0.5) {
    scale = size.zy;
} else if (abs((scn_node.inverseModelViewTransform * float4(_surface.normal, 0.0)).y) > 0.5) {
    scale = size.xz;
} else {
    scale = size.xy;
}

// Compute threshold for discarding rendering
float2 thresh = float2(lineThickness) / scale;
if (u > thresh[0] && u < (1.0 - thresh[0]) && v > thresh[1] && v < (1.0 - thresh[1])) {
    discard_fragment();
}
