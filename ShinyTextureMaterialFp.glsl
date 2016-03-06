#version 400

// Attributes passed from the vertex shader
in vec3 position_interp;
in vec3 normal_interp;
in vec4 colour_interp;
in vec2 uv_interp;
in vec3 light_pos;

// Attributes passed with the material file
uniform vec4 ambient_colour;
uniform vec4 diffuse_colour;
uniform vec4 specular_colour;
uniform float ambient_amount;
uniform float phong_exponent;
uniform sampler2D diffuse_map;


void main() 
{
    // Blinn–Phong shading

    vec3 N, // Interpolated normal for fragment
	     L, // Light-source direction
		 V, // View direction
		 H; // Half-way vector

	// Compute Lambertian lighting
    N = normalize(normal_interp);

	L = (light_pos - position_interp);
	L = normalize(L);

	float lambertian_amount = max(dot(N, L), 0.0);
	
	// Compute specular term for Blinn–Phong shading
	V = - position_interp; // Eye position is (0, 0, 0)
    V = normalize(V);

    H = 0.5*(V + L);
    H = normalize(H);

    float spec_angle_cos = max(dot(N, H), 0.0);
	float specular_amount = pow(spec_angle_cos, phong_exponent);
	    
	// Retrieve texture value
	vec4 pixel = texture(diffuse_map, uv_interp);

	// Use texture in determining fragment colour
	//gl_FragColor = pixel;
	gl_FragColor = (ambient_amount + lambertian_amount)*pixel + specular_amount*specular_colour;
	//gl_FragColor = (ambient_amount + lambertian_amount + specular_amount)*pixel;
}