int matrice[][] = new int[20][30];
int bombsNbr = 100;
int nbrbombs = bombsNbr;
int bombs[][] = new int[bombsNbr][2];
boolean lost = false;
boolean won = false;
PImage bomb;
PImage flag;
PImage numbers[] = new PImage[7];
int nbrCases = 0;
int matriceColored[][] = new int[20][30];
int lastPoint = 0;

void setup()
{
	size(400, 630);
	background(51);
	fill(#004080);
	noStroke();
	rect(0, 0, 400, 30);
	PImage smile = loadImage("smile.png");
	bomb = loadImage("bomb.png");
	flag = loadImage("flag.png");
	for (int i = 0 ; i < 7 ; i++)
	{
		numbers[i] = loadImage((i+1)+".png");
	}
	image(smile, 175, 2, 25, 25);
	

	for (int i = 0 ; i < 20 ; i ++)
	{
		for (int j = 0  ; j  < 30 ; j++)
		{
			matrice[i][j] = 0;
			matriceColored[i][j] = 0;
		}
	}

	for (int i = 0 ; i < bombsNbr ; i ++)
	{
		boolean ok;
		int x;
		int y;

		do{
			ok = true;
			x = floor(random(0, 20));
			y = floor(random(0, 30));

			if (matrice[x][y] == -1)
			{
				ok = false;
			}
		}while(!ok);
		matrice[x][y] = -1;
		bombs[i][0] = x;
		bombs[i][1] = y;
		addVoisinage(x, y);
		
	}

	draw2();
}

void inc(int x, int y)
{
	if (matrice[x][y] != -1)
	{
		matrice[x][y]++;
	}
}

void addVoisinage(int x, int y)
{

	if (x == 0 && y == 0)
	{
		inc(x+1,y);
		inc(x+1,y+1);
		inc(x,y+1);
	}
	if (x == 19 && y == 0)
	{
		inc(x-1,y);
		inc(x-1,y+1);
		inc(x,y+1);
	}
	if (x == 0 && y == 29)
	{
		inc(x,y-1);
		inc(x+1,y-1);
		inc(x+1,y);
	}
	if (x == 19 && y == 29)
	{
		inc(x,y-1);
		inc(x-1,y-1);
		inc(x-1,y);
	}

	if (x > 0 && x < 19 && y == 0)
	{
		inc(x-1,y);
		inc(x+1,y);
		inc(x,y+1);
		inc(x-1,y+1);
		inc(x+1,y+1);
	}

	if (x > 0 && x < 19 && y == 29)
	{
		inc(x-1,y);
		inc(x+1,y);
		inc(x,y-1);
		inc(x-1,y-1);
		inc(x+1,y-1);
	}

	if (y > 0 && y < 29 && x == 0)
	{
		inc(x,y-1);
		inc(x,y+1);
		inc(x+1,y);
		inc(x+1,y+1);
		inc(x+1,y-1);
	}

	if (y > 0 && y < 29 && x == 19)
	{
		inc(x,y-1);
		inc(x,y+1);
		inc(x-1,y);
		inc(x-1,y+1);
		inc(x-1,y-1);
	}

	if (x > 0 && x < 19 && y > 0 && y < 29)
	{
		inc(x,y-1);
		inc(x,y+1);
		inc(x+1,y);
		inc(x+1,y+1);
		inc(x+1,y-1);
		inc(x-1,y);
		inc(x-1,y+1);
		inc(x-1,y-1);
	}

}

void restart()
{
	setup();
	lost = false;
	won = false;
	nbrCases = 0;
	nbrbombs = bombsNbr;
	lastPoint = millis();
}

void colorCase(int x, int y)
{
	if (matrice[x][y] > 0)
	{
		fill(#181A15);
		rect(x*20, y*20 + 30, 20, 20);
		image(numbers[matrice[x][y]-1], x*20+2, y*20 + 32, 18, 18);
		matriceColored[x][y] = 1;
	}
	else if (matrice[x][y] == -2) 
	{
		fill(#181A15);
		rect(x*20, y*20 + 30, 20, 20);
		matriceColored[x][y] = 1;	
	}
}

void expand(int x, int y)
{
	boolean colored = false;
	if(matrice[x][y] > 0)
	{
		colorCase(x,y);
		colored = true;
	}
	if (matrice[x][y] != -2)
	{

		matrice[x][y] = -2;
		if (x < 19)
			if (matrice[x+1][y] == 0)
			{
				expand(x+1, y);
			}
			else 
			{
				colorCase(x+1,y);
			}
		if (y < 29)
			if (matrice[x][y+1] == 0)
			{
				expand(x, y+1);
			}
			else 
			{
				colorCase(x,y+1);
			}
		if (x > 0)
			if (matrice[x-1][y] == 0)
			{
				expand(x-1, y);
			}
			else 
			{
				colorCase(x-1,y);
			}
		if (y > 0)
			if (matrice[x][y-1] == 0)
			{
				expand(x, y-1);
			}
			else 
			{
				colorCase(x,y-1);
			}
		if (!colored)
			colorCase(x,y);
	}
}

void mouseClicked()
{
	int X = mouseX / 20;
  int Y = (mouseY - 30) /20 ;
	if (mouseButton == LEFT)
	{
		if (mouseY > 30  && !won && !lost)
		{

			if (matrice[X][Y] == -1)
			{
				lost = true;
				image(bomb, X*20, Y*20 + 30, 20, 20);
			}
			else
			{
				if (matrice[X][Y] != -2)
					expand(X, Y);
			}
		}
		else if (mouseX > 175 && mouseX < 200 && mouseY > 2 && mouseY < 27) {		
			restart();
		}
		
	}
	else if (nbrbombs > 0)
	{
		nbrbombs--;
		image(flag, X*20, Y*20 + 30, 20, 20);
	}
	countCases();
}

void draw2()
{
	
	strokeWeight(1);
	stroke(0);
	fill(#C0C0C0);
	for (int i = 0 ; i < 20; i++)
	{
		for (int j = 0 ; j < 30; j++)
		{
			rect(i*20,30+ j*20, 20, 20);
		}
	}
}

void drawLost()
{
	fill(#000000);
	rect(100, 250, 200, 100);
	fill(255);
	textSize(35);
	text("YOU LOST", 200, 310);
}

void drawWon()
{
	fill(#000000);
	rect(100, 250, 200, 100);
	fill(255);
	textSize(35);
	text("YOU WON", 200, 310);
}

void draw()
{
	if(nbrCases == 30*20-bombsNbr)
	{
		won = true;
	}

	if (!lost && !won)
	{
		fill(#000040);
		rect(50, 3, 70, 24);
		rect(250, 3, 70, 24);
		fill(#FF0000);
		textSize(20);
		textAlign(CENTER);
		text(nbrbombs, 80, 23);
		text((millis()-lastPoint)/1000, 285, 23);
	}
	else if(won)
		{
			drawWon();
		}else {
			drawLost();
		}{
		
		}
}

void countCases()
{
	nbrCases = 0;
	for (int i = 0 ; i < 20 ; i++)
	{
		for (int  j = 0 ; j < 30 ; j++)
		{
			if (matriceColored[i][j] == 1)
				nbrCases++;
		}
	}
}
