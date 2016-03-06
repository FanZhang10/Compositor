#version 400

// Attributes passed from the vertex shader
in vec3 position_interp;
in vec3 normal_interp;
in vec4 colour_interp;
in vec3 light_pos;
in vec3 light_pos2;

// Attributes passed with the material file
uniform vec4 ambient_colour;
uniform vec4 diffuse_colour;
uniform vec4 specular_colour;
uniform float phong_exponent;
uniform int type;

void main() 
{
    // Blinn–Phong shading

    vec3 N, // Interpolated normal for fragment
	     L, // Light-source direction
		 L2,
		 V, // View direction
		 H, // Half-way vector
		 R,
		 R2; //Reflection

	// Compute Lambertian lighting Id
    N = normalize(normal_interp);

	L = (light_pos - position_interp);
	L = normalize(L);
	L2 = (light_pos2 - position_interp);
	L2 = normalize(L2);

	float Id = max(dot(N, L), 0.0);
	float Id2 = max(dot(N, L2), 0.0);
	
	// Compute specular term for Blinn–Phong shading
	// Initially: V = (eye_position - position_interp);
	V = - position_interp; // Eye position is (0, 0, 0) in view coordinates
    V = normalize(V);

    H = 0.5*(V + L); // Halfway vector
    H = normalize(H);

	//for Q1 plain Phong (V.R)
	R = reflect(-L, N);
	R2 = reflect(-L2, N);
	//R = 2*dot(N, L)*N -L;
	float spec_angle_cos = max(dot(V, R), 0.0);
	float spec_angle_cos2 = max(dot(V, R2), 0.0);

    //float spec_angle_cos = max(dot(N, H), 0.0);
	float Is = pow(spec_angle_cos, phong_exponent);
	float Is2 = pow(spec_angle_cos2, phong_exponent);
	    
	// Assign light to the fragment
	if(type == 0)
		gl_FragColor = ambient_colour + (Id+Id2)/2*diffuse_colour + (Is+Is2)/2*specular_colour;
	
	if(type == 1)
	{
			float intensity = (Id+Id2)/2+(Is+Is2)/2;
			vec4 color;
			if (intensity > 0.95)
				color = vec4(1.0,0.5,0.5,1.0);
			else if (intensity > 0.5)
				color = vec4(0.6,0.3,0.3,1.0);
			else if (intensity > 0.25)
				color = vec4(0.4,0.2,0.2,1.0);
			else
				color = vec4(0.2,0.1,0.1,1.0);
			gl_FragColor = color;
			
			if(dot(V, N) < 0.2)
			{
				gl_FragColor = vec4(0.0,0.0,0.0,1.0);
			}


	}

	// For debug, we can display the different values
	//gl_FragColor = ambient_colour;
	//gl_FragColor = diffuse_colour;
	//gl_FragColor = specular_colour;
	//gl_FragColor = colour_interp;
	//gl_FragColor = vec4(N.xyz, 1.0);
	//gl_FragColor = vec4(L.xyz, 1.0);
	//gl_FragColor = vec4(V.xyz, 1.0);
}
