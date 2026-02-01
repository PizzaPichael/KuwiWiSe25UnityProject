using UnityEngine;
using UnityEngine.SceneManagement;
public class MainMenu : MonoBehaviour
{
    public void StartTracker()
    {
        SceneManager.LoadScene(1);
    }

    public void OpenProjectGithub()
    {
        Application.OpenURL("https://github.com/PizzaPichael/KuwiWiSe25UnityProject");
    }

    public void OpenDavidGithub()
    {
        Application.OpenURL("https://github.com/davidkirch");
    }

    public void OpenMichaelGithub()
    {
        Application.OpenURL("https://github.com/PizzaPichael");
    }

    public void ExitTracker()
    {
        Application.Quit();
    }
}