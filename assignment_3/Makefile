CXX = g++
CFLAGS = -Wall -Wextra -std=c++11

SRCS = main.cpp $(wildcard geometry/*.cpp)
OBJS = $(patsubst %.cpp,%.o,$(SRCS))
DEPS = $(wildcard geometry/*.h)

TARGET = main
.SILENT:

$(TARGET): $(OBJS)
	@$(CXX) $(CFLAGS) $^ -o $@

geometry/%.o: ./%.cpp $(DEPS)
	@$(CXX) $(CFLAGS) -c $< -o $@

.PHONY: clean

clean:
	@rm -f geometry/*.o
	@rm -f *.o
	@rm -f $(TARGET)
