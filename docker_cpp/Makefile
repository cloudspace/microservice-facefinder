LIB_PATH = `pkg-config --libs --cflags opencv`

detectFaces: detectFaces.cpp
	g++ -Wall detectFaces.cpp -o detectFaces -static $(LIB_PATH)
