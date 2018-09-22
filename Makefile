BASEDIR	:= $(dir $(firstword $(MAKEFILE_LIST)))
VPATH	:= $(BASEDIR)

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing header files
# RESOURCES is a list of resources to be included in the file
#---------------------------------------------------------------------------------
TARGET		:=	Minesweeper
SOURCES		:=	source
INCLUDES	:=	
RESOURCES	:=	resources

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
CFLAGS		+=	-DUSE_SDL_INPUT $(INCLUDES)
CXXFLAGS	+=	$(CFLAGS)
LDFLAGS		+=	$(WUT_NEWLIB_LDFLAGS) $(WUT_STDCPP_LDFLAGS) $(WUT_DEVOPTAB_LDFLAGS) \
				-lSDL2_ttf -lfreetype -lpng -lSDL2_gfx -lSDL2_image -lSDL2 -ljpeg -lzip \
				-lcoreinit -lvpad -lsysapp -lproc_ui -lgx2 -lgfd -lzlib125 -lwhb

#---------------------------------------------------------------------------------
# get a list of objects
#---------------------------------------------------------------------------------
CFILES		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
SFILES		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.s))
PNGFILES	:=	$(foreach dir,$(RESOURCES),$(wildcard $(dir)/*.png))
OBJECTS		:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o) $(PNGFILES:.png=.o)

#---------------------------------------------------------------------------------
# objectives
#---------------------------------------------------------------------------------
$(TARGET).rpx: $(OBJECTS)

%.o : %.png
	@echo RES $(notdir $<)
	@mkdir -p $(dir $*)
	@$(OBJCOPY) --input binary --output elf32-powerpc --binary-architecture powerpc:common $< $@

clean:
	rm -rf $(TARGET).rpx $(OBJECTS) $(OBJECTS:.o=.d)

#---------------------------------------------------------------------------------
# wut
#---------------------------------------------------------------------------------
include $(WUT_ROOT)/share/wut.mk

#---------------------------------------------------------------------------------
# portlibs
#---------------------------------------------------------------------------------
PORTLIBS	:=	$(DEVKITPRO)/portlibs/ppc
LDFLAGS		+=	-L$(PORTLIBS)/lib
CFLAGS		+=	-I$(PORTLIBS)/include -I$(PORTLIBS)/include/SDL2
CXXFLAGS	+=	-I$(PORTLIBS)/include -I$(PORTLIBS)/include/SDL2