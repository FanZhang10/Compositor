#version 400

// Passed from the vertex shader
in vec2 uv;

// Passed from outside
uniform float time;
uniform sampler2D diffuse_map;
uniform int effect;


void main() 
{
	if(effect == 0)
		gl_FragColor = texture(diffuse_map, uv);

	if(effect == 1)
	{
		// wavering
		vec2 pos = uv;
		pos.x = pos.x + 0.05*(sin(time/10.0+8.0*pos.y));

		vec4 pixel = texture(diffuse_map, pos);
    
		gl_FragColor = pixel;
	}

	if(effect == 2)
	{
		//Blur
		
		//find out the pixel size
		float px = 1.0/100;
		float py = 1.0/100;

		//for each pixel, calculate the average color of a 5x5 neighborhood
		vec4 tempColor = vec4(0.0,0.0,0.0,1.0);
		for(int i=-2; i<3;i++){
			for(int j=-2; j<3; j++){
				tempColor += texture(diffuse_map, uv+vec2(px*i, py*j) );
			}
		}
		tempColor = tempColor * (1.0/25.0);
		gl_FragColor = tempColor;
		
	}
	
	if(effect == 3)
	{
		//2X2 tiling of the scene 
		
		vec2 splitScreen = vec2(0,0);
		splitScreen.x = uv.x*2;
		splitScreen.y = uv.y*2;
		gl_FragColor = texture(diffuse_map, splitScreen );
		
	}

	if(effect == 4)
	{
		//horizontal wipe 
		
		float distToLeft = uv.x;

		float sweepCurve =  time/500.0+ 0.1;

		if(distToLeft<sweepCurve)
			gl_FragColor = vec4(0.0,0.0,1.0,1.0);
		else
			gl_FragColor = texture(diffuse_map, uv );
		
	}
	
	if(effect == 5)
	{
		//heart beat
		
		vec4 color = texture(diffuse_map, uv );
		float delta = 0.0;
		if(sin(time/24.0)>0)
			delta = 0.8*abs(sin(time/12.0));
		else
			delta = 0;
		color.r += delta;
		color.g -= delta;
		color.b -= delta;
		gl_FragColor = color;
		
	}

	if(effect == 6)
	{
		//shockwave 
	
		  float shockParams = 80.0;
		  vec2 texCoord = uv;
		  vec2 center = vec2(0.5,0.5);
		  float distace = distance(uv, center);
		  if ( (distace <= ( time/1000 + 0.1)) && 
			   (distace >= ( time/1000 - 0.1)) ) 
		  {
			float diff = (distace - time/1000 ); 
			float powDiff = 1.0 - pow(abs(diff*10.0), 
										0.8); 
			float diffTime = diff  * powDiff; 
			vec2 diffUV = normalize(uv - center); 
			texCoord = uv + (diffUV * diffTime);
		  } 
		  gl_FragColor = texture2D(diffuse_map, texCoord);
	
	 }
}

