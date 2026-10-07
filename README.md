# Projekt-z-JP-nr-1
Projekt nr 1 z JP

# Slimerancher

Project written in Ada for the Programming Language subject (JP). Below is a setup guide for **VS Code** with **Alire** and the **Ada/SPARK** extension.

## Requirements

This project requires **Alire** (`alr`) for managing dependencies, compiling, and running the Ada project.

1. Download Alire from: [Alire Downloads](https://alire.ada.dev/)
2. Run the installer and finish the installation.
3. Add the Alire `bin` folder to your system `PATH` variable. Usually it is installed in a folder similar to:

   ```powershell
   C:\Users\<your-user>\alire\bin
   ```

4. Verify that Alire is installed correctly:

   ```bash
   alr --version
   ```

## Clone and configure the project

After cloning the repository, open the project folder and go to the Ada project directory:

```bash
git clone <repository-url>
cd Projekt-z-JP-nr-1
cd slimerancher
```
or if you use github desktop, just use clone repo option in repositories tab.

Update the local Alire index and fetch dependencies:

```bash
alr update
alr get
```

>The `alr get` command downloads the required crates and tools for the project, and `alr update` refreshes the package index so Alire can resolve dependencies correctly.

## VS Code configuration

To work comfortably with Ada files in Visual Studio Code:

1. Install the **Ada & SPARK** extension in VS Code.
2. Open the cloned repository folder.
3. Open the project root or the `slimerancher` folder as the workspace.

Example :

```bash
cd Projekt-z-JP-nr-1\slimerancher
alr update
alr get
alr build
alr run
```
