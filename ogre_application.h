#ifndef OGRE_APPLICATION_H_
#define OGRE_APPLICATION_H_

#include <exception>
#include <string>

#include "OGRE/OgreRoot.h"
#include "OGRE/OgreViewport.h"
#include "OGRE/OgreCamera.h"
#include "OGRE/OgreHardwarePixelBuffer.h"
#include "OGRE/OgreRenderSystem.h"
#include "OGRE/OgreRenderWindow.h"
#include "OGRE/OgreWindowEventUtilities.h"
#include "OGRE/OgreManualObject.h"
#include "OGRE/OgreEntity.h"
#include "OGRE/OgreCompositorManager.h"
#include "OGRE/OgreCompositorInstance.h"
#include "OIS/OIS.h"

namespace ogre_application {


	/* A useful type to define */
	typedef std::vector<Ogre::String> Strings;

	/* Our exception type */
	class OgreAppException: public std::exception
    {
		private:
		    std::string message_;
	    public:
			OgreAppException(std::string message) : message_(message) {};
			virtual const char* what() const throw() { return message_.c_str(); };
	};

	/* Material listener for updating the compositor materials */
	class OgreApplication;
	class MaterialListener : public Ogre::CompositorInstance::Listener
	{
		public:
			void Init(OgreApplication *app);
			virtual void notifyMaterialSetup(Ogre::uint32 pass_id, Ogre::MaterialPtr &mat);
			virtual void notifyMaterialRender(Ogre::uint32 pass_id, Ogre::MaterialPtr &mat);

		private:
			OgreApplication *app_;
	};

	/* Our Ogre application */
	class OgreApplication :
	    public Ogre::FrameListener, // Derive from FrameListener to be able to have event callbacks
        public Ogre::WindowEventListener {

		friend class MaterialListener;

        public:
            OgreApplication(void);
            void Init(void); // Call Init() before running the main loop
			// Create geometry of a torus and add it to the available resources
			void CreateTorusGeometry(Ogre::String object_name, float loop_radius = 0.6, float circle_radius = 0.2, int num_loop_samples = 90, int num_circle_samples = 30); 
			// Create an entity of an object that we can show on the screen
            void CreateEntity(Ogre::String entity_name, Ogre::String object_name, Ogre::String material_name);
			void SetupAnimation(Ogre::String entity_name); // Setup animation for an object
            void MainLoop(void); // Keep application active

			void CreateCylinder(void); // Create the geometry for a single Cylinder
			void CreateMultipleCylinders(void);
			void CreateTorus(Ogre::String object_name, Ogre::String material_name, float loop_radius = 0.6, float circle_radius = 0.2, int num_loop_samples = 90, int num_circle_samples = 30); // Create an object to show on the screen
			void CreateMultipleTorus(void);

        private:
			// Create root that allows us to access Ogre commands
            std::auto_ptr<Ogre::Root> ogre_root_;
            // Application main Ogre window
            Ogre::RenderWindow* ogre_window_;

			// For animating the sphere
			Ogre::AnimationState *animation_state_; // Keep state of the animation
			bool animating_; // Whether animation is on or off
			bool space_down_; // Whether space key was pressed

			// Input managers
			OIS::InputManager *input_manager_;
			OIS::Mouse *mouse_;
			OIS::Keyboard *keyboard_;

			// Objects used for compositor
			Ogre::Camera* camera_;
			float elapsed_time_;
			MaterialListener material_listener_;
			int effect;
			#define NUM_ELEMENTS 6 // Number of elements in the chain
			#define NUM_ELEMENTS_TORUS 2
			Ogre::SceneNode* torus_[NUM_ELEMENTS_TORUS]; 
			Ogre::SceneNode* cylinder_[NUM_ELEMENTS*2];

			/* Methods to initialize the application */
			void InitRootNode(void);
			void InitPlugins(void);
			void InitRenderSystem(void);
			void InitWindow(void);
			void InitViewport(void);
			void InitFrameListener(void);
			void InitOIS(void);
			void LoadMaterials(void);
			void InitCompositor(void);
			/* Methods to handle events */
			bool frameEnded(const Ogre::FrameEvent &fe); 	
			bool frameRenderingQueued(const Ogre::FrameEvent& fe);

    }; // class OgreApplication

} // namespace ogre_application;

#endif // OGRE_APPLICATION_H_
