defmodule <%= web_module %>.<%= scoped %>Live.Helpers do
  use <%= web_module %>, :component

  def placeholder(assigns) do
    assigns =
      assigns
      |> assign_new(:height, fn -> "150px" end)
      |> assign_new(:style, fn -> "" end)

    ~H"""
    <div style={"
      height: #{@height};
      line-height: #{@height};
      text-align: center;
      vertical-align: middle;
      background-color: gray;
      color: white;
      font-size: 2em;
      font-weight: 700;
      #{@style}
    "}><%%= render_slot(@inner_block) %></div>
    """
  end

  def lorem_ipsum(assigns) do
    assigns = assign_new(assigns, :paragraphs, fn -> "15" end)

    ~H"""
    <%%=
      lorem_ipsum_paragraphs(String.to_integer(assigns[:paragraphs]))
      |> Enum.map(&"<p>#{&1}</p>")
      |> Phoenix.HTML.raw()
    %>
    """
  end

  defp lorem_ipsum_paragraphs(count) do
    [
      "Incididunt adipisicing nostrud consectetur quis eiusmod in. Reprehenderit dolor aliquip tempor occaecat magna aliqua enim eiusmod proident. Occaecat veniam commodo dolore est elit sint dolore occaecat. Voluptate officia incididunt est magna anim consectetur dolore nisi commodo laboris. Eu sit non eu pariatur incididunt cillum nulla nulla qui reprehenderit ex.",
      "Consectetur occaecat cillum enim ipsum sit culpa veniam aute occaecat. Mollit cupidatat amet tempor exercitation nisi reprehenderit velit tempor. Qui sunt amet ipsum sit labore irure deserunt pariatur. Mollit velit nisi ea officia aute. Sunt commodo qui reprehenderit ipsum. Ipsum irure commodo aliquip enim deserunt cupidatat sint sint dolore aliquip ullamco esse reprehenderit. Et est qui ut ullamco amet velit qui voluptate qui cillum labore.",
      "Magna sunt dolore anim id duis deserunt cupidatat enim. Eu voluptate in do ea nisi quis anim. Labore ex laborum labore proident minim eiusmod est sint culpa officia do aute labore in. Culpa ut voluptate aute sit. Duis commodo ad sint esse deserunt ut nisi nostrud in. Sit et magna cupidatat est id reprehenderit aute adipisicing ea exercitation officia aute consectetur sit.",
      "Eu id nisi qui excepteur officia sit labore eu reprehenderit ut ex occaecat. Mollit commodo incididunt in Lorem veniam duis. Occaecat nulla amet minim sunt quis laborum.",
      "Qui occaecat incididunt culpa ut sint ut. Ullamco cupidatat Lorem duis cillum laborum mollit nisi consectetur laborum qui enim veniam exercitation dolor. Qui officia adipisicing velit cillum et aute quis consequat. Ullamco dolor dolore irure mollit eiusmod. Laboris laborum ad id exercitation aliquip cillum.",
      "Id qui labore nostrud labore Lorem consectetur. Proident exercitation aliquip nisi cillum quis laboris ut occaecat. Ad incididunt ex incididunt occaecat aute consequat nisi id in irure consectetur. Sit exercitation ex aute nulla duis enim. Incididunt ex consequat in consequat velit nisi voluptate in officia sunt. Et minim reprehenderit sunt Lorem officia reprehenderit sit velit voluptate.",
      "Dolor voluptate do aliquip veniam ullamco sit eu. Anim aliquip nisi enim ad laborum reprehenderit laboris enim ipsum officia eiusmod aliqua velit. Cillum labore sit ad minim cillum enim voluptate aliquip velit non occaecat fugiat cupidatat. Anim amet in velit tempor laborum aliqua laborum tempor.",
      "Ad non ipsum qui aliqua magna occaecat. Elit ad amet ullamco dolor minim consequat ipsum. Voluptate excepteur in irure proident. Velit eu magna id ut ut aliquip nisi deserunt consequat consectetur nulla eiusmod eiusmod ut. Ad reprehenderit magna amet enim ut enim velit. Sunt exercitation dolore labore mollit aute elit incididunt ea in non tempor pariatur aliquip exercitation.",
      "Aliqua nostrud enim adipisicing qui fugiat laborum dolore cupidatat ullamco labore enim elit. Quis laboris velit mollit aliquip pariatur aute laboris nulla velit et in velit et. Et ipsum mollit enim nostrud amet cillum id.",
      "Exercitation occaecat esse irure aliqua amet. Proident fugiat id do elit in eu. Mollit voluptate aute anim ipsum duis. Officia ex adipisicing eiusmod excepteur sunt velit tempor laborum Lorem mollit est quis.",
      "Laborum irure proident in ea dolore dolor nostrud. Aute aute ea nisi velit dolor enim minim deserunt aliqua excepteur in sint aliquip. Duis ullamco excepteur veniam reprehenderit aute. Est et irure nostrud proident laboris occaecat dolore occaecat veniam labore consectetur adipisicing. Incididunt incididunt ex deserunt non nostrud exercitation nisi culpa laboris quis duis. Sunt elit cupidatat sint enim qui officia ad excepteur aute fugiat Lorem do fugiat.",
      "Est mollit duis fugiat consequat enim non dolor id et sint non eu labore. Magna aute incididunt consectetur ex quis ad voluptate aliquip occaecat magna. Non commodo reprehenderit proident adipisicing cupidatat irure do. Est aliquip fugiat nulla culpa tempor ipsum in cillum. Laboris fugiat magna non nostrud reprehenderit in pariatur enim incididunt duis reprehenderit aliqua.",
      "Occaecat proident enim consequat sunt. Sunt velit tempor qui ullamco tempor laboris ut nisi reprehenderit. Sint voluptate ipsum laborum elit esse qui aliquip aliquip non non aliquip. Labore magna officia aliqua mollit amet qui fugiat minim reprehenderit esse aute.",
      "Ad nisi mollit labore occaecat ullamco ullamco fugiat enim ullamco sit voluptate ullamco sint amet. Ex ullamco qui ullamco exercitation sunt pariatur adipisicing aliqua aliqua adipisicing ex. Sint adipisicing proident esse elit cillum nulla cillum ex cillum incididunt deserunt. Esse pariatur incididunt consequat occaecat exercitation velit. Ad aliqua dolore consectetur ut aliqua ex occaecat quis dolore. Cillum duis consectetur id in cupidatat non cupidatat commodo et incididunt. Anim enim cillum laboris cupidatat do dolor minim sunt mollit ut.",
      "Sint adipisicing sint ipsum ad incididunt consectetur esse. Commodo amet magna ad tempor minim sit culpa enim occaecat dolore qui quis adipisicing sunt. Id proident veniam enim fugiat ipsum fugiat esse aliquip. Irure adipisicing officia fugiat qui non cillum ut reprehenderit anim nostrud fugiat eiusmod."
    ]
    |> Enum.take(count)
  end
end
