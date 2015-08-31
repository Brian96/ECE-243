void target()
{

	PLOT_5x5_SQUARE(0x9900, 300, 150, 0x5);

	PLOT_5x5_SQUARE(0xcc66, 298, 155, 0xc);

	PLOT_RECTANGLE(0xcc33, 303, 167, 0x2);

	PLOT_RIGHT_DIAGONAL(0x66ff, 298, 175, 0x6);

	PLOT_LEFT_DIAGONAL(0x66ff, 296, 175, 0x6);

	PLOT_RIGHT_DIAGONAL(0x66ff, 298, 202, 0x6);

	PLOT_LEFT_DIAGONAL(0x66ff, 296, 202, 0x6);

	PLOT_5x5_SQUARE(0x0000, 300, 159, 0x2);

}


void tank(int level)
{

	if(level == 1)
	{
		PLOT_TANK(0xffff, 180, 200, 0x16);

		PLOT_LEFT_DIAGONAL(0xff99, 185, 190, 0xa);
	}

	else if(level == 2)
	{
		PLOT_TANK(0xffff, 130, 200, 0x16);

		PLOT_LEFT_DIAGONAL(0xff99, 135, 190, 0xa);
	}

	else if(level == 3)
	{
		PLOT_TANK(0xffff, 30, 200, 0x16);

		PLOT_LEFT_DIAGONAL(0xff99, 35, 190, 0xa);
	}




}