# Julia-Set

</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)  ![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) ![None](https://github.com/user-attachments/assets/30ebe930-c928-4aaf-a8e1-5f68ec1ff349)  
![Description](https://github.com/user-attachments/assets/dbf330e0-633c-4b31-a0ef-b1edb9ed5aa7) ![Julia](https://github.com/user-attachments/assets/41f6c3f0-25f0-484b-9c7a-e48467ae1197)  ![Mandelbrot Quantity](https://github.com/user-attachments/assets/9aaf1101-6ff7-4b29-97f2-f8c9c85b1b2b)  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) ![032026](https://github.com/user-attachments/assets/b90ecb2e-201e-4d60-8211-1d8df59d5213)  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)  

</br>

In [complex dynamics](https://en.wikipedia.org/wiki/Complex_dynamics), the Julia set and the Fatou set are two [complementary sets](https://en.wikipedia.org/wiki/Complement_(set_theory)) (Julia "laces" and Fatou "dusts") defined from a function. Informally, the Fatou set of the function consists of values with the property that all nearby values behave similarly under [repeated iteration](https://en.wikipedia.org/wiki/Iterated_function) of the function, and the Julia set consists of values such that an arbitrarily small [perturbation](https://en.wikipedia.org/wiki/Perturbation_theory) can cause drastic changes in the sequence of iterated function values. Thus the behavior of the function on the Fatou set is "regular", while on the Julia set its behavior is "[chaotic](https://en.wikipedia.org/wiki/Chaos_theory)".

The Julia set of a function ```f```  is commonly denoted ```J(f)``` and the Fatou set is denoted ```F(J)``` These sets are named after the French mathematicians [Gaston Julia](https://en.wikipedia.org/wiki/Gaston_Julia) and [Pierre Fatou](https://en.wikipedia.org/wiki/Pierre_Fatou) whose work began the study of complex dynamics during the early 20th century.

</Br>

![Julia](https://github.com/user-attachments/assets/c73787c3-9ff8-4898-be15-fdb75526ce81)

</br>

[Gaston Maurice Julia](https://en.wikipedia.org/wiki/Gaston_Julia) (3 February 1893 – 19 March 1978) was a French mathematician who devised the formula for the Julia set. His works were popularized by Benoit Mandelbrot; the Julia and Mandelbrot fractals are closely related. He founded, independently with Pierre Fatou, the modern theory of holomorphic dynamics.

### Julia Set Animation

Animated Julia SetIt's a sequence of Julia sets for the points at 5° intervals around the unit circle. It's something I wrote up in an edition of Fractal Report in the early 1990s. I animated it then in BASIC on an Amiga 500. Now, it's more accessible as a GIF animation, and the code (in an eclectic mix of Fortran77 and Perl) is presented for your "enjoyment".

Explanations of the mathematics are in Peitgen & Saupe's book The Science of Fractal Images, Springer-Verlag. They do it better than I ever could.

</br>

![JSr07885](https://github.com/user-attachments/assets/ffcf522a-7078-4f8e-b1b5-1081291de69d)

</br>

### Painting Julia

```pascal
procedure TForm1.PaintJulia(xf,yf:double;imagenummer:integer;sender:tobject);
var
  a,b,cx,cy,da,db,radius,gwert:real;
  i,it : word;
  x,y,breite,hoehe:integer;
  rowrgb : pbytearray;
begin
    gwert:=groesse;
    breite:=juliabitmap.width;
    hoehe:=juliabitmap.height;

    jufaktor:=hoehe/breite;
    it :=150;
    radius:=4;
    da := gwert/breite;
    db := jufaktor*gwert/hoehe;
    cx := xf;
    cy := yf;
    b := jufaktor*gwert/2;

    FOR y:=0 TO hoehe-1 DO
    BEGIN
      rowrgb:=juliabitmap.scanline[y];
      b := b - db;
      a := -gwert/2;
      FOR x:=0 TO breite-1 DO
      BEGIN
        a := a + da;
      ASM
         FLD     radius    { 9        }
         FLD     a         { cx       9 }
         FLD     b         { cy       cx    9     }
         FLD     st        { y        cy    cx    9    }
         FMUL    st,st     { y²       cy    cx    9    }
         FLD     st(2)     { x        y²    cy    cx    9     }
         FMUL    st,st     { x²       y²    cy    cx    9     }
         FLD     st(2)     { y        x²    y²    cy    cx    9     }
         FLD     st(4)     { x        y     x²    y²    cy    cx    9   }

         XOR     cx,cx
@itloop: INC     cx        { CX is the iteration counter   }
         CMP     cx,it     { CX exceeds the value it,      }
         JE      @noloop   { then do not set a pixel.      }

         { y = 2xy + b }
         FMUL              { xy       x²    y²    cy    cx    9     }
         FADD    st,st     { 2xy      x²    y²    cy    cx    9     }
         FADD    cy        { (y)      x²    y²    cy    cx    9     }
         { x = x² - y² + a }
         FLD     st(1)     { x²       (y)   x²    y²    cy    cx    9     }
         FSUB    st,st(3)  { x²-y²    (y)   x²    y²    cy    cx    9     }
         FADD    &cx       { (x)      (y)   x²    y²    cy    cx    9     }
         { x² = x*x }
         FST     st(3)     { (x)      (y)   x²    (x)   cy    cx    9     }
         FMUL    st,st     { (x²)     (y)   x²    (x)   cy    cx    9     }
         FSTP    st(2)     { (y)      (x²)  (x)   cy    cx    9     }
         { y² = y*y }
         FLD     st        { (y)      (y)   (x²)  (x)   cy    cx    9     }
         FMUL    st,st     { (y²)     (y)   (x²)  (x)   cy    cx    9     }
         { x² + y² < 9 ??? }
         FADD    st,st(2)  { (x²+y²)  (y)   (x²)  (x)   cy    cx    9     }
         FCOM    st(6)     { (x²+y²)  (y)   (x²)  (x)   cy    cx    9     }
         FSTSW   ax
         FSUB    st,st(2)  { (y²)     (y)   (x²)  (x)   cy    cx    9     }
         FXCH    st(3)     { (x)      (y)   (x²)  (y²)  cy    cx    9     }
         AND     ah,1
         JNZ     @itloop   { If the sequence is within the circle, then continue. }
@noloop: MOV     i, cx
         FINIT
      END;
        if i>=it then i:=0
                 else i:=i mod 256;
        farbfeld[imagenummer,x,y]:=i;
        rowrgb[3*x]:=pal[i].b;
        rowrgb[3*x+1]:=pal[i].g;
        rowrgb[3*x+2]:=pal[i].r;
      END;
    END;

    if checkbox1.checked then
    begin
      juliabitmap.canvas.brush.style:=bsclear;
      juliabitmap.canvas.font.name:='Verdana';
      juliabitmap.canvas.TextOut(5,5,'c = '+_strkomma(xf,1,2)+' '+
                                vorzeichenzahlkomma(yf,1,2)+'·i');
    end;

         case imagenummer of
          1 : julia1.canvas.draw(0,0,juliabitmap);
          2 : julia2.canvas.draw(0,0,juliabitmap);
          3 : julia3.canvas.draw(0,0,juliabitmap);
          4 : julia4.canvas.draw(0,0,juliabitmap);
          5 : julia5.canvas.draw(0,0,juliabitmap);
          6 : julia6.canvas.draw(0,0,juliabitmap);
        end;
end;
```

# Mandelbrot Quantity  
The Mandelbrot set is a two-dimensional set that is defined in the [complex plane](https://en.wikipedia.org/wiki/Complex_plane) as the [complex numbers](https://en.wikipedia.org/wiki/Complex_number) ```c``` for which the function ```fc(z)=z²+c``` does not diverge to infinity when iterated starting at ```z=0``` for which the sequence ```fc(0), fc(fc(0))``` etc., remains bounded in absolute value.

This set was first defined and drawn by Robert W. Brooks and Peter Matelski in 1978, as part of a study of Kleinian groups. Afterwards, in 1980, [Benoit Mandelbrot](https://en.wikipedia.org/wiki/Benoit_Mandelbrot) obtained high-quality visualizations of the set while working at IBM's Thomas J. Watson Research Center in Yorktown Heights, New York.

</br>

![Mandelbrot](https://github.com/user-attachments/assets/c4f5ddcf-dda0-485d-ad66-b478c7c4c47b)

</br>

The Mandelbrot set is a [compact set](https://en.wikipedia.org/wiki/Compact_space), since it is closed and contained in the closed disk of radius 2 centred on zero. A point ```c``` belongs to the Mandelbrot set if and only if ```|z| <2``` for all ```n>0``` In other words, the [absolute value](https://en.wikipedia.org/wiki/Absolute_value) of ```zn``` must remain at or below 2 for ```c``` to be in the Mandelbrot set, ```M``` and if that absolute value exceeds 2, the sequence will escape to infinity. Since ```c=z1``` , it follows that ```|c|<2``` establishing that ```c``` will always be in the closed disk of radius 2 around the origin. 

# Mandelbrot Animation  
[Self-similarity](https://en.wikipedia.org/wiki/Self-similarity) in the Mandelbrot set shown by zooming in on a round feature while panning in the negative-x direction. The display center pans left from the fifth to the seventh round feature (−1.4002, 0) to (−1.4011, 0) while the view magnifies by a factor of 21.78 to approximate the square of the [Feigenbaum ratio](https://en.wikipedia.org/wiki/Feigenbaum_constants).

</br>

![Self-Similarity-Zoom](https://github.com/user-attachments/assets/aca2a262-b7c6-40fc-a274-401d14465151)

</br>
