# OCaml Mandelbrot Set Viewer

This program will generate images of the Mandelbrot set and other arbitrary polynomials.

<img width="1276" alt="Screenshot 2023-04-30 at 9 20 40 PM" src="https://user-images.githubusercontent.com/35178804/235389121-f39897b5-2788-4c73-a6f7-96edf9797e19.png">

To use the program: 
1. Install xquartz. If you're on MacOS, you can install it with homebrew via `brew install xquartz`. Otherwise, you can install it from their website. 
2. The version of OCaml I used was `4.12.0`, so ensure you have an environment with that version. 
3. Install OCaml's graphics module with `opam install graphics`. 
4. Run `make all`.
5. Run `./main.byte`. 

To zoom into an area, just click on the screen once and then again to denote the area. Press `q` to quit or `e` to enhance the picture by increasing the number of iterations. You can adjust the resolution, coloring, function to be used for fractal generation, and complex region to calculate. All configuration settings are in `config.ml`. 

Some pictures generated with the software:

<img width="1279" alt="Screenshot 2023-04-30 at 9 43 59 PM" src="https://user-images.githubusercontent.com/35178804/235389157-741f7a62-5251-49bc-adf6-bd4edf77a3e7.png">

<img width="1601" alt="Screenshot 2023-05-02 at 5 03 21 PM" src="https://user-images.githubusercontent.com/35178804/235786306-073b54be-b26d-474b-84d3-dc04b23a8125.png">

<img width="1600" alt="Screenshot 2023-05-02 at 5 08 21 PM" src="https://user-images.githubusercontent.com/35178804/235786587-8fa8c03a-a7ec-410d-9b5a-bbf387ef2ee5.png">

<img width="1601" alt="Screenshot 2023-05-02 at 5 10 06 PM" src="https://user-images.githubusercontent.com/35178804/235786934-6482167e-2f23-4f53-970a-50b8f1ee6d31.png">

<img width="1599" alt="Screenshot 2023-05-02 at 5 17 52 PM" src="https://user-images.githubusercontent.com/35178804/235788828-a2a10ddf-90fc-4a30-8275-4e56f37fd343.png">

<img width="1600" alt="Screenshot 2023-05-02 at 5 20 19 PM" src="https://user-images.githubusercontent.com/35178804/235788851-0a1fed56-4676-4729-bbf6-aa674459cdfc.png">
